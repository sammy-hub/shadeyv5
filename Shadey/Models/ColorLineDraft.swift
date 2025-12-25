import Foundation

struct ColorLineDraft {
    var brand: String
    var name: String
    var productTypeId: String
    var unit: UnitType
    var quantityPerUnit: Double?
    var purchasePrice: Double?
    var defaultDeveloperRatio: Double?
    var defaultDeveloperId: UUID?

    init(
        brand: String = "",
        name: String = "",
        productTypeId: String = ProductType.permanent.rawValue,
        unit: UnitType = .ounces,
        quantityPerUnit: Double? = nil,
        purchasePrice: Double? = nil,
        defaultDeveloperRatio: Double? = nil,
        defaultDeveloperId: UUID? = nil
    ) {
        self.brand = brand
        self.name = name
        self.productTypeId = productTypeId
        self.unit = unit
        self.quantityPerUnit = quantityPerUnit
        self.purchasePrice = purchasePrice
        self.defaultDeveloperRatio = defaultDeveloperRatio
        self.defaultDeveloperId = defaultDeveloperId
    }

    init(colorLine: ColorLine) {
        brand = colorLine.brand
        name = colorLine.name
        productTypeId = colorLine.defaultProductTypeRaw
        unit = colorLine.defaultUnit
        quantityPerUnit = colorLine.defaultQuantityPerUnit
        purchasePrice = colorLine.defaultPurchasePrice
        defaultDeveloperRatio = colorLine.defaultDeveloperRatio
        defaultDeveloperId = colorLine.defaultDeveloper?.id
    }
}
