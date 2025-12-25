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
        }.sorted { $0.0.name < $1.0.name }
    }

    var valueByBrand: [(String, Double)] {
        let grouped = Dictionary(grouping: inventoryStore.products, by: { $0.resolvedBrand })
        return grouped.map { brand, products in
            let value = products.reduce(0) { $0 + ($1.stockQuantity * $1.costPerUnit) }
            return (brand, value)
        }.sorted { $0.0 < $1.0 }
    }

    var usageTrends: [(String, Int)] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: recentServices) { service in
            calendar.date(from: calendar.dateComponents([.year, .month], from: service.date)) ?? service.date
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        return grouped.keys.sorted().map { date in
            let label = formatter.string(from: date)
            let count = grouped[date]?.count ?? 0
            return (label, count)
        }
    }

    func refresh() {
        inventoryStore.reload()
        clientsStore.reload()
    }
}
