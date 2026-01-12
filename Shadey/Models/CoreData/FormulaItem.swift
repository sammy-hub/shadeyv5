import CoreData

@objc(FormulaItem)
public final class FormulaItem: NSManagedObject {}

extension FormulaItem {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FormulaItem> {
        NSFetchRequest<FormulaItem>(entityName: "FormulaItem")
    }

    @NSManaged public var amountUsed: Double
    @NSManaged public var cost: Double
    @NSManaged public var id: UUID
    @NSManaged public var ratioPart: Double
    @NSManaged public var product: Product?
    @NSManaged public var service: Service?
    @NSManaged public var serviceFormula: ServiceFormula?
}
