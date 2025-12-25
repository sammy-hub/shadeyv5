import CoreData

@objc(ColorLine)
public final class ColorLine: NSManagedObject {
    var defaultProductTypeId: String {
        get { defaultProductTypeRaw }
        set { defaultProductTypeRaw = newValue }
    }

    var defaultProductType: ProductType {
        get { ProductType(rawValue: defaultProductTypeRaw) ?? .permanent }
        set { defaultProductTypeRaw = newValue.rawValue }
    }

    var defaultUnit: UnitType {
        get { UnitType(rawValue: defaultUnitRaw) ?? .ounces }
        set { defaultUnitRaw = newValue.rawValue }
    }

    var costPerUnit: Double {
        guard defaultQuantityPerUnit > 0 else { return 0 }
        return defaultPurchasePrice / defaultQuantityPerUnit
    }

    var displayName: String {
        "\(brand) \(name)"
    }
}

extension ColorLine {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ColorLine> {
        NSFetchRequest<ColorLine>(entityName: "ColorLine")
    }

    @NSManaged public var brand: String
    @NSManaged public var createdAt: Date
    @NSManaged public var defaultDeveloperRatio: Double
    @NSManaged public var defaultProductTypeRaw: String
    @NSManaged public var defaultPurchasePrice: Double
    @NSManaged public var defaultQuantityPerUnit: Double
    @NSManaged public var defaultUnitRaw: String
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var updatedAt: Date
    @NSManaged public var defaultDeveloper: Product?
    @NSManaged public var shades: Set<Product>?
}

extension ColorLine: Identifiable {}
