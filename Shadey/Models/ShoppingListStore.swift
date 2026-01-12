import CoreData
import Observation

@MainActor
@Observable
final class ShoppingListStore {
    private let context: NSManagedObjectContext
    private let stockAlertSettingsStore: StockAlertSettingsStore
    private let preferencesStore: ShoppingListPreferencesStore
    private(set) var items: [ShoppingListItem] = []

    init(
        context: NSManagedObjectContext,
        stockAlertSettingsStore: StockAlertSettingsStore,
        preferencesStore: ShoppingListPreferencesStore
    ) {
        self.context = context
        self.stockAlertSettingsStore = stockAlertSettingsStore
        self.preferencesStore = preferencesStore
        reload()
    }

    func reload() {
        let request = ShoppingListItem.fetchRequest()
        request.sortDescriptors = [
            NSSortDescriptor(keyPath: \ShoppingListItem.isPinned, ascending: false),
            NSSortDescriptor(keyPath: \ShoppingListItem.createdAt, ascending: false)
        ]
        do {
            items = try context.fetch(request)
        } catch {
            items = []
        }
    }

    func addItemIfNeeded(for product: Product) {
        updateAutoList(for: product)
    }

    func restock(item: ShoppingListItem) {
        guard let product = item.product else {
            context.delete(item)
            saveContext()
            reload()
            return
        }
        product.stockQuantity += item.quantityNeeded
        product.updatedAt = .now
        context.delete(item)
        saveContext()
        reload()
    }

    func markPurchased(item: ShoppingListItem) {
        if preferencesStore.autoRestockOnPurchase {
            restock(item: item)
            return
        }
        item.isChecked = true
        saveContext()
        reload()
    }

    func undoPurchased(item: ShoppingListItem) {
        item.isChecked = false
        saveContext()
        reload()
    }

    func updateAutoList(for product: Product) {
        guard !product.autoAddDisabled else {
            removeAutoItems(for: product)
            return
        }

        let threshold = stockAlertSettingsStore.threshold(for: product)
        let isDepleted = product.stockQuantity <= 0
        let isLowStock = threshold > 0 && product.stockQuantity <= threshold

        if isDepleted || isLowStock {
            let reason: ShoppingListItemReason = isDepleted ? .depleted : .lowStock
            upsertAutoItem(for: product, reason: reason, threshold: threshold)
        } else {
            removeAutoItems(for: product)
        }
    }

    func addManualItem(for product: Product, quantity: Double, note: String?) {
        let existing = items.first { $0.product?.id == product.id }
        let item = existing ?? ShoppingListItem(context: context)
        if existing == nil {
            item.id = UUID()
            item.createdAt = .now
            item.product = product
        }
        item.quantityNeeded = max(quantity, 0)
        item.isChecked = false
        item.isPinned = true
        item.note = trimmed(note)
        item.reasonRaw = ShoppingListItemReason.manual.rawValue
        saveContext()
        reload()
    }

    func update(item: ShoppingListItem, quantity: Double, note: String?, isPinned: Bool) {
        item.quantityNeeded = max(quantity, 0)
        item.note = trimmed(note)
        item.isPinned = isPinned
        saveContext()
        reload()
    }

    private func upsertAutoItem(for product: Product, reason: ShoppingListItemReason, threshold: Double) {
        let existing = items.first { $0.product?.id == product.id && $0.reason != .manual }
        let item = existing ?? ShoppingListItem(context: context)
        if existing == nil {
            item.id = UUID()
            item.createdAt = .now
            item.product = product
            item.isPinned = false
        }
        item.isChecked = false
        item.reasonRaw = reason.rawValue
        item.quantityNeeded = suggestedQuantity(for: product, threshold: threshold)
        saveContext()
        reload()
    }

    private func removeAutoItems(for product: Product) {
        let autoItems = items.filter { $0.product?.id == product.id && $0.reason != .manual }
        for item in autoItems {
            context.delete(item)
        }
        guard !autoItems.isEmpty else { return }
        saveContext()
        reload()
    }

    private func suggestedQuantity(for product: Product, threshold: Double) -> Double {
        let base = threshold > 0 ? threshold : product.resolvedQuantityPerUnit
        return max(base, product.resolvedQuantityPerUnit)
    }

    private func trimmed(_ value: String?) -> String? {
        guard let value else { return nil }
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
}
