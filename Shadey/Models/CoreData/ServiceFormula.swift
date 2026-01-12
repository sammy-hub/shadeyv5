import CoreData

@objc(ServiceFormula)
public final class ServiceFormula: NSManagedObject {
    public var formulaItemsArray: [FormulaItem] {
        let set = formulaItems ?? []
        return set.sorted { ($0.product?.resolvedBrand ?? "") < ($1.product?.resolvedBrand ?? "") }
    }
}

extension ServiceFormula {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ServiceFormula> {
        NSFetchRequest<ServiceFormula>(entityName: "ServiceFormula")
    }

    @NSManaged public var developerAmountUsed: Double
    @NSManaged public var developerRatio: Double
    @NSManaged public var id: UUID
    @NSManaged public var name: String?
    @NSManaged public var sortOrder: Int16
    @NSManaged public var totalCost: Double
    @NSManaged public var developer: Product?
    @NSManaged public var formulaItems: Set<FormulaItem>?
    @NSManaged public var service: Service?
}
