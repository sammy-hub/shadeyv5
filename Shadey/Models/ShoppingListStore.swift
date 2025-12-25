import CoreData
import Observation

@MainActor
@Observable
final class ShoppingListStore {
    private let context: NSManagedObjectContext
    private(set) var items: [ShoppingListItem] = []

    init(context: NSManagedObjectContext) {
        self.context = context
        reload()
    }

    func reload() {
        let request = ShoppingListItem.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \ShoppingListItem.createdAt, ascending: false)]
        do {
            items = try context.fetch(request)
        } catch {
            items = []
        }
    }

    func addItemIfNeeded(for product: Product) {
        if items.contains(where: { $0.product?.id == product.id }) {
            return
        }
        let item = ShoppingListItem(context: context)
        item.id = UUID()
        item.createdAt = .now
        item.quantityNeeded = product.suggestedReorderQuantity
        item.isChecked = false
        item.product = product
        saveContext()
        reload()
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

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
}
