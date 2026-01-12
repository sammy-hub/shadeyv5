import Foundation
import Observation

@MainActor
@Observable
final class ShoppingListViewModel {
    private let store: ShoppingListStore
    private let inventoryStore: InventoryStore
    private let preferencesStore: ShoppingListPreferencesStore
    private let stockAlertSettingsStore: StockAlertSettingsStore

    init(
        store: ShoppingListStore,
        inventoryStore: InventoryStore,
        preferencesStore: ShoppingListPreferencesStore,
        stockAlertSettingsStore: StockAlertSettingsStore
    ) {
        self.store = store
        self.inventoryStore = inventoryStore
        self.preferencesStore = preferencesStore
        self.stockAlertSettingsStore = stockAlertSettingsStore
    }

    var activeItems: [ShoppingListItem] {
        store.items.filter { !$0.isChecked }
    }

    var purchasedItems: [ShoppingListItem] {
        store.items.filter { $0.isChecked }
    }

    var groupedActiveItems: [ShoppingListBrandGroup] {
        groupedItems(from: activeItems)
    }

    var groupedPurchasedItems: [ShoppingListBrandGroup] {
        groupedItems(from: purchasedItems)
    }

    var autoRestockOnPurchase: Bool {
        preferencesStore.autoRestockOnPurchase
    }

    func restock(item: ShoppingListItem) {
        store.restock(item: item)
    }

    func markPurchased(item: ShoppingListItem) {
        store.markPurchased(item: item)
    }

    func undoPurchased(item: ShoppingListItem) {
        store.undoPurchased(item: item)
    }

    func addManualItem(product: Product, quantity: Double, note: String?) {
        store.addManualItem(for: product, quantity: quantity, note: note)
    }

    func update(item: ShoppingListItem, quantity: Double, note: String?, isPinned: Bool) {
        store.update(item: item, quantity: quantity, note: note, isPinned: isPinned)
    }

    func refresh() {
        store.reload()
    }

    func searchProducts(matching query: String) -> [Product] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }
        return inventoryStore.products.filter { product in
            product.displayName.localizedStandardContains(trimmed)
                || product.resolvedBrand.localizedStandardContains(trimmed)
                || product.shadeLabel.localizedStandardContains(trimmed)
                || inventoryStore.productTypeStore.displayName(for: product.resolvedProductTypeId)
                    .localizedStandardContains(trimmed)
                || (product.colorLine?.name.localizedStandardContains(trimmed) ?? false)
        }
        .sorted { $0.displayName.localizedStandardCompare($1.displayName) == .orderedAscending }
    }

    func effectiveLowStockThreshold(for product: Product) -> Double {
        stockAlertSettingsStore.threshold(for: product)
    }

    private func groupedItems(from items: [ShoppingListItem]) -> [ShoppingListBrandGroup] {
        let withProduct = items.compactMap { item -> (ShoppingListItem, Product)? in
            guard let product = item.product else { return nil }
            return (item, product)
        }

        let brandGroups = Dictionary(grouping: withProduct, by: { $0.1.resolvedBrand })
        let mapped = brandGroups.map { brand, entries -> ShoppingListBrandGroup in
            let lineGroups = Dictionary(grouping: entries, by: { entry in
                entry.1.colorLine?.name ?? "Unassigned"
            })
            let lineMapped = lineGroups.map { lineName, lineEntries -> ShoppingListLineGroup in
                let typeGroups = Dictionary(grouping: lineEntries, by: { entry in
                    inventoryStore.productTypeStore.displayName(for: entry.1.resolvedProductTypeId)
                })
                let typeMapped = typeGroups.map { typeName, typeEntries -> ShoppingListTypeGroup in
                    let items = typeEntries.map { $0.0 }.sorted { lhs, rhs in
                        if lhs.isPinned == rhs.isPinned {
                            return lhs.createdAt > rhs.createdAt
                        }
                        return lhs.isPinned && !rhs.isPinned
                    }
                    return ShoppingListTypeGroup(id: "\(lineName)-\(typeName)", name: typeName, items: items)
                }
                .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
                return ShoppingListLineGroup(id: lineName, name: lineName, typeGroups: typeMapped)
            }
            .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
            return ShoppingListBrandGroup(id: brand, brand: brand, lineGroups: lineMapped)
        }

        return mapped.sorted { $0.brand.localizedStandardCompare($1.brand) == .orderedAscending }
    }
}
