import CoreData

@objc(Product)
public final class Product: NSManagedObject {
    var resolvedBrand: String {
        colorLine?.brand ?? brand
    }

    var productTypeId: String {
        get { productTypeRaw }
        set { productTypeRaw = newValue }
    }

    var productType: ProductType {
        get { ProductType(rawValue: productTypeRaw) ?? .permanent }
        set { productTypeRaw = newValue.rawValue }
    }

    var resolvedProductTypeId: String {
        if let overrideProductTypeRaw {
            return overrideProductTypeRaw
        }
        if let colorLine {
            return colorLine.defaultProductTypeRaw
        }
        return productTypeRaw
    }

    var resolvedProductType: ProductType {
        if let overrideProductTypeRaw,
           let override = ProductType(rawValue: overrideProductTypeRaw) {
            return override
        }
        if let colorLine {
            return colorLine.defaultProductType
        }
        return productType
    }

    var unit: UnitType {
        get { UnitType(rawValue: unitRaw) ?? .ounces }
        set { unitRaw = newValue.rawValue }
    }

    var resolvedUnit: UnitType {
        if let overrideUnitRaw,
           let override = UnitType(rawValue: overrideUnitRaw) {
            return override
        }
        if let colorLine {
            return colorLine.defaultUnit
        }
        return unit
    }

    var resolvedQuantityPerUnit: Double {
        overrideQuantityPerUnit?.doubleValue ?? colorLine?.defaultQuantityPerUnit ?? quantityPerUnit
    }

    var resolvedPurchasePrice: Double {
        overridePurchasePrice?.doubleValue ?? colorLine?.defaultPurchasePrice ?? purchasePrice
    }

    var resolvedDefaultDeveloperRatio: Double {
        overrideDefaultDeveloperRatio?.doubleValue ?? colorLine?.defaultDeveloperRatio ?? defaultDeveloperRatio
    }

    public var costPerUnit: Double {
        guard resolvedQuantityPerUnit > 0 else { return 0 }
        return resolvedPurchasePrice / resolvedQuantityPerUnit
    }

    var stockStatus: StockStatus {
        if stockQuantity <= lowStockThreshold {
            return .low
        }
        if stockQuantity >= overstockThreshold, overstockThreshold > 0 {
            return .overstock
        }
        return .normal
    }

    public var displayName: String {
        if let lineName = colorLine?.name, !lineName.isEmpty {
            return "\(resolvedBrand) \(lineName) \(shadeLabel)"
        }
        return "\(resolvedBrand) \(shadeLabel)"
    }

    public var suggestedReorderQuantity: Double {
        if lowStockThreshold > 0 {
            return max(lowStockThreshold, resolvedQuantityPerUnit)
        }
        return resolvedQuantityPerUnit
    }

    var shadeLabel: String {
        let code = (shadeCode ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
        let nameValue = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !code.isEmpty {
            if nameValue.isEmpty || nameValue.localizedStandardCompare(code) == .orderedSame {
                return code
            }
            return "\(code) \(nameValue)"
        }
        return nameValue
    }
}

extension Product {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var barcode: String?
    @NSManaged public var brand: String
    @NSManaged public var createdAt: Date
    @NSManaged public var defaultDeveloperRatio: Double
    @NSManaged public var developerStrength: Int16
    @NSManaged public var id: UUID
    @NSManaged public var lowStockThreshold: Double
    @NSManaged public var name: String
    @NSManaged public var notes: String?
    @NSManaged public var overstockThreshold: Double
    @NSManaged public var overrideDefaultDeveloperRatio: NSNumber?
    @NSManaged public var overrideProductTypeRaw: String?
    @NSManaged public var overridePurchasePrice: NSNumber?
    @NSManaged public var overrideQuantityPerUnit: NSNumber?
    @NSManaged public var overrideUnitRaw: String?
    @NSManaged public var productTypeRaw: String
    @NSManaged public var purchasePrice: Double
    @NSManaged public var quantityPerUnit: Double
    @NSManaged public var recommendedDeveloperStrength: Int16
    @NSManaged public var shadeCode: String?
    @NSManaged public var stockQuantity: Double
    @NSManaged public var unitRaw: String
    @NSManaged public var updatedAt: Date
    @NSManaged public var colorLine: ColorLine?
    @NSManaged public var defaultDeveloperLines: NSSet?
    @NSManaged public var developerServices: NSSet?
    @NSManaged public var formulaItems: NSSet?
    @NSManaged public var shoppingListItems: NSSet?
}
