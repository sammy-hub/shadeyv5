import XCTest
@testable import Shadey

final class ServiceCalculatorTests: XCTestCase {
    func testDeveloperAmountUsesRatio() {
        let product = Product(context: PersistenceController.preview.viewContext)
        product.id = UUID()
        product.name = "Test"
        product.brand = "Brand"
        product.productType = .permanent
        product.unit = .ounces
        product.quantityPerUnit = 2
        product.purchasePrice = 10
        product.stockQuantity = 1
        product.lowStockThreshold = 0
        product.overstockThreshold = 0
        product.defaultDeveloperRatio = 1.5
        product.developerStrength = 0
        product.recommendedDeveloperStrength = 0
        product.createdAt = .now
        product.updatedAt = .now
        product.autoAddDisabled = false

        let selection = FormulaSelection(product: product, amountUsed: 2, ratioPart: 1)
        let developerAmount = ServiceCalculator.developerAmount(for: [selection], ratio: 1.5)

        XCTAssertEqual(developerAmount, 3, accuracy: 0.001)
    }

    func testTotalCostAddsDeveloperCost() {
        let developer = Product(context: PersistenceController.preview.viewContext)
        developer.id = UUID()
        developer.name = "Dev"
        developer.brand = "Brand"
        developer.productType = .developer
        developer.unit = .ounces
        developer.quantityPerUnit = 32
        developer.purchasePrice = 16
        developer.stockQuantity = 1
        developer.lowStockThreshold = 0
        developer.overstockThreshold = 0
        developer.defaultDeveloperRatio = 0
        developer.developerStrength = 20
        developer.recommendedDeveloperStrength = 0
        developer.createdAt = .now
        developer.updatedAt = .now
        developer.autoAddDisabled = false

        let color = Product(context: PersistenceController.preview.viewContext)
        color.id = UUID()
        color.name = "Color"
        color.brand = "Brand"
        color.productType = .permanent
        color.unit = .ounces
        color.quantityPerUnit = 2
        color.purchasePrice = 10
        color.stockQuantity = 1
        color.lowStockThreshold = 0
        color.overstockThreshold = 0
        color.defaultDeveloperRatio = 1.5
        color.developerStrength = 0
        color.recommendedDeveloperStrength = 0
        color.createdAt = .now
        color.updatedAt = .now
        color.autoAddDisabled = false

        let selection = FormulaSelection(product: color, amountUsed: 2, ratioPart: 1)
        let totalCost = ServiceCalculator.totalCost(
            selections: [selection],
            developer: developer,
            developerAmount: 3
        )

        let expected = (2 * color.costPerUnit) + (3 * developer.costPerUnit)
        XCTAssertEqual(totalCost, expected, accuracy: 0.001)
    }

    func testTotalCostAddsMultipleSelections() {
        let context = PersistenceController.preview.viewContext

        let shadeOne = Product(context: context)
        shadeOne.id = UUID()
        shadeOne.name = "Shade One"
        shadeOne.brand = "Brand"
        shadeOne.productType = .permanent
        shadeOne.unit = .ounces
        shadeOne.quantityPerUnit = 2
        shadeOne.purchasePrice = 10
        shadeOne.stockQuantity = 1
        shadeOne.lowStockThreshold = 0
        shadeOne.overstockThreshold = 0
        shadeOne.defaultDeveloperRatio = 1
        shadeOne.developerStrength = 0
        shadeOne.recommendedDeveloperStrength = 0
        shadeOne.createdAt = .now
        shadeOne.updatedAt = .now
        shadeOne.autoAddDisabled = false

        let shadeTwo = Product(context: context)
        shadeTwo.id = UUID()
        shadeTwo.name = "Shade Two"
        shadeTwo.brand = "Brand"
        shadeTwo.productType = .permanent
        shadeTwo.unit = .ounces
        shadeTwo.quantityPerUnit = 3
        shadeTwo.purchasePrice = 12
        shadeTwo.stockQuantity = 1
        shadeTwo.lowStockThreshold = 0
        shadeTwo.overstockThreshold = 0
        shadeTwo.defaultDeveloperRatio = 1
        shadeTwo.developerStrength = 0
        shadeTwo.recommendedDeveloperStrength = 0
        shadeTwo.createdAt = .now
        shadeTwo.updatedAt = .now
        shadeTwo.autoAddDisabled = false

        let selectionOne = FormulaSelection(product: shadeOne, amountUsed: 2, ratioPart: 1)
        let selectionTwo = FormulaSelection(product: shadeTwo, amountUsed: 1.5, ratioPart: 1)

        let totalCost = ServiceCalculator.totalCost(
            selections: [selectionOne, selectionTwo],
            developer: nil,
            developerAmount: 0
        )

        let expected = (2 * shadeOne.costPerUnit) + (1.5 * shadeTwo.costPerUnit)
        XCTAssertEqual(totalCost, expected, accuracy: 0.001)
    }
}
