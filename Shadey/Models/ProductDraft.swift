import Foundation

struct ProductDraft {
    var name: String
    var shadeCode: String
    var notes: String
    var brand: String
    var productTypeId: String
    var unit: UnitType
    var quantityPerUnit: Double?
    var purchasePrice: Double?
    var stockQuantity: Double?
    var lowStockThreshold: Double?
    var overstockThreshold: Double?
    var barcode: String
    var developerStrength: DeveloperStrength?
    var defaultDeveloperRatio: Double?
    var recommendedDeveloperStrength: DeveloperStrength?
    var autoAddDisabled: Bool

    init(
        name: String = "",
        shadeCode: String = "",
        notes: String = "",
        brand: String = "",
        productTypeId: String = ProductType.permanent.rawValue,
        unit: UnitType = .ounces,
        quantityPerUnit: Double? = nil,
        purchasePrice: Double? = nil,
        stockQuantity: Double? = nil,
        lowStockThreshold: Double? = nil,
        overstockThreshold: Double? = nil,
        barcode: String = "",
        developerStrength: DeveloperStrength? = nil,
        defaultDeveloperRatio: Double? = nil,
        recommendedDeveloperStrength: DeveloperStrength? = nil,
        autoAddDisabled: Bool = false
    ) {
        self.name = name
        self.shadeCode = shadeCode
        self.notes = notes
        self.brand = brand
        self.productTypeId = productTypeId
        self.unit = unit
        self.quantityPerUnit = quantityPerUnit
        self.purchasePrice = purchasePrice
        self.stockQuantity = stockQuantity
        self.lowStockThreshold = lowStockThreshold
        self.overstockThreshold = overstockThreshold
        self.barcode = barcode
        self.developerStrength = developerStrength
        self.defaultDeveloperRatio = defaultDeveloperRatio
        self.recommendedDeveloperStrength = recommendedDeveloperStrength
        self.autoAddDisabled = autoAddDisabled
    }

    init(product: Product) {
        name = product.name
        shadeCode = product.shadeCode ?? ""
        notes = product.notes ?? ""
        brand = product.resolvedBrand
        productTypeId = product.resolvedProductTypeId
        unit = product.resolvedUnit
        quantityPerUnit = product.resolvedQuantityPerUnit
        purchasePrice = product.resolvedPurchasePrice
        stockQuantity = product.stockQuantity
        lowStockThreshold = product.lowStockThreshold
        overstockThreshold = product.overstockThreshold
        barcode = product.barcode ?? ""
        developerStrength = DeveloperStrength(rawValue: product.developerStrength)
        defaultDeveloperRatio = product.resolvedDefaultDeveloperRatio
        recommendedDeveloperStrength = DeveloperStrength(rawValue: product.recommendedDeveloperStrength)
        autoAddDisabled = product.autoAddDisabled
    }
}
