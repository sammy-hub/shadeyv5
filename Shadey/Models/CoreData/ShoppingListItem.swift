import CoreData

@objc(ShoppingListItem)
public final class ShoppingListItem: NSManagedObject {}

extension ShoppingListItem {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShoppingListItem> {
        NSFetchRequest<ShoppingListItem>(entityName: "ShoppingListItem")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var id: UUID
    @NSManaged public var isChecked: Bool
    @NSManaged public var quantityNeeded: Double
    @NSManaged public var product: Product?
}
