import Foundation
import Observation

@MainActor
@Observable
final class DashboardViewModel {
    private let inventoryStore: InventoryStore
    private let clientsStore: ClientsStore

    init(inventoryStore: InventoryStore, clientsStore: ClientsStore) {
        self.inventoryStore = inventoryStore
        self.clientsStore = clientsStore
    }

    var totalInventoryValue: Double {
        inventoryStore.totalInventoryValue()
    }

    var hasInventory: Bool {
        !inventoryStore.products.isEmpty
    }

    var hasClients: Bool {
        !clientsStore.clients.isEmpty
    }

    var shouldShowEmptyState: Bool {
        !hasInventory && !hasClients
    }

    var totalClients: Int {
        clientsStore.clients.count
    }

    var lowStockCount: Int {
        inventoryStore.products.filter { $0.stockStatus == .low }.count
    }

    var overstockCount: Int {
        inventoryStore.products.filter { $0.stockStatus == .overstock }.count
    }

    var recentServices: [Service] {
        let services = clientsStore.clients.flatMap { $0.sortedServices }
        return services.sorted { $0.date > $1.date }
    }

    var stockByType: [(ProductTypeDefinition, Double)] {
        let grouped = Dictionary(grouping: inventoryStore.products, by: { $0.resolvedProductTypeId })
        return grouped.map { typeId, products in
            let total = products.reduce(0) { $0 + $1.stockQuantity }
            let definition = inventoryStore.productTypeStore.definition(for: typeId)
            return (definition, total)
        }.sorted { $0.0.name.localizedStandardCompare($1.0.name) == .orderedAscending }
    }

    var valueByBrand: [(String, Double)] {
        let grouped = Dictionary(grouping: inventoryStore.products, by: { $0.resolvedBrand })
        return grouped.map { brand, products in
            let value = products.reduce(0) { $0 + ($1.stockQuantity * $1.costPerUnit) }
            return (brand, value)
        }.sorted { $0.0.localizedStandardCompare($1.0) == .orderedAscending }
    }

    var usageTrends: [(String, Int)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: recentServices) { service in
            calendar.date(from: calendar.dateComponents([.year, .month], from: service.date)) ?? service.date
        }
        return grouped.keys.sorted().map { date in
            let label = date.formatted(AppFormatters.monthOnly)
            let count = grouped[date]?.count ?? 0
            return (label, count)
        }
    }

    func refresh() {
        inventoryStore.reload()
        clientsStore.reload()
    }
}
