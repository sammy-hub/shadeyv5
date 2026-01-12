import CoreData

@objc(Service)
public final class Service: NSManagedObject {
    public var formulaItemsArray: [FormulaItem] {
        let set = formulaItems ?? []
        return set.sorted { $0.product?.resolvedBrand ?? "" < $1.product?.resolvedBrand ?? "" }
    }

    public var formulaGroupsArray: [ServiceFormula] {
        let set = formulaGroups ?? []
        return set.sorted { $0.sortOrder < $1.sortOrder }
    }
}

extension Service {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Service> {
        NSFetchRequest<Service>(entityName: "Service")
    }

    @NSManaged public var afterPhoto: Data?
    @NSManaged public var beforePhoto: Data?
    @NSManaged public var date: Date
    @NSManaged public var developerAmountUsed: Double
    @NSManaged public var developerRatio: Double
    @NSManaged public var id: UUID
    @NSManaged public var notes: String?
    @NSManaged public var totalCost: Double
    @NSManaged public var client: Client?
    @NSManaged public var developer: Product?
    @NSManaged public var formulaGroups: Set<ServiceFormula>?
    @NSManaged public var formulaItems: Set<FormulaItem>?
}
