import CoreData
import XCTest
@testable import Shadey

@MainActor
final class FormulaDeveloperRuleEngineTests: XCTestCase {
    func testSuggestedRatioUsesOverride() {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.viewContext
        let productTypeStore = ProductTypeStore()

        let product = Product(context: context)
        product.id = UUID()
        product.name = "Color"
        product.brand = "Brand"
        product.productType = .permanent
        product.unit = .ounces
        product.quantityPerUnit = 2
        product.purchasePrice = 10
        product.stockQuantity = 1
        product.lowStockThreshold = 0
        product.overstockThreshold = 0
        product.defaultDeveloperRatio = 1
        product.overrideDefaultDeveloperRatio = NSNumber(value: 2.5)
        product.developerStrength = 0
        product.recommendedDeveloperStrength = 0
        product.createdAt = .now
        product.updatedAt = .now
        product.autoAddDisabled = false

        let selection = FormulaSelection(product: product, amountUsed: 1, ratioPart: 1)
        let suggestion = FormulaDeveloperRuleEngine.suggestedRatio(
            for: [selection],
            productTypeStore: productTypeStore
        )

        XCTAssertEqual(suggestion.ratio, 2.5, accuracy: 0.001)
        XCTAssertEqual(suggestion.source, .productOverride)
    }

    func testSuggestedRatioUsesLineDefault() {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.viewContext
        let productTypeStore = ProductTypeStore()

        let line = ColorLine(context: context)
        line.id = UUID()
        line.brand = "Brand"
        line.name = "Line"
        line.defaultProductTypeRaw = ProductType.permanent.rawValue
        line.defaultUnit = .ounces
        line.defaultQuantityPerUnit = 2
        line.defaultPurchasePrice = 10
        line.defaultDeveloperRatio = 1.75
        line.createdAt = .now
        line.updatedAt = .now

        let product = Product(context: context)
        product.id = UUID()
        product.name = "Color"
        product.brand = "Brand"
        product.productType = .permanent
        product.unit = .ounces
        product.quantityPerUnit = 2
        product.purchasePrice = 10
        product.stockQuantity = 1
        product.lowStockThreshold = 0
        product.overstockThreshold = 0
        product.defaultDeveloperRatio = 1
        product.developerStrength = 0
        product.recommendedDeveloperStrength = 0
        product.createdAt = .now
        product.updatedAt = .now
        product.autoAddDisabled = false
        product.colorLine = line

        let selection = FormulaSelection(product: product, amountUsed: 1, ratioPart: 1)
        let suggestion = FormulaDeveloperRuleEngine.suggestedRatio(
            for: [selection],
            productTypeStore: productTypeStore
        )

        XCTAssertEqual(suggestion.ratio, 1.75, accuracy: 0.001)
        XCTAssertEqual(suggestion.source, .lineDefault)
    }

    func testSuggestedRatioUsesProductDefaultWhenNoLineDefault() {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.viewContext
        let productTypeStore = ProductTypeStore()

        let product = Product(context: context)
        product.id = UUID()
        product.name = "Color"
        product.brand = "Brand"
        product.productType = .permanent
        product.unit = .ounces
        product.quantityPerUnit = 2
        product.purchasePrice = 10
        product.stockQuantity = 1
        product.lowStockThreshold = 0
        product.overstockThreshold = 0
        product.defaultDeveloperRatio = 1.25
        product.developerStrength = 0
        product.recommendedDeveloperStrength = 0
        product.createdAt = .now
        product.updatedAt = .now
        product.autoAddDisabled = false

        let selection = FormulaSelection(product: product, amountUsed: 1, ratioPart: 1)
        let suggestion = FormulaDeveloperRuleEngine.suggestedRatio(
            for: [selection],
            productTypeStore: productTypeStore
        )

        XCTAssertEqual(suggestion.ratio, 1.25, accuracy: 0.001)
        XCTAssertEqual(suggestion.source, .productDefault)
    }
}
