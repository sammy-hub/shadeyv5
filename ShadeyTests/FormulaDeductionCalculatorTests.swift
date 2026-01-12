import CoreData
import XCTest
@testable import Shadey

@MainActor
final class FormulaDeductionCalculatorTests: XCTestCase {
    func testNewUnitDeductionUsesQuantityPerUnit() {
        let context = PersistenceController(inMemory: true).viewContext
        let product = Product(context: context)
        product.id = UUID()
        product.name = "Color"
        product.brand = "Brand"
        product.productType = .permanent
        product.unit = .ounces
        product.quantityPerUnit = 2
        product.purchasePrice = 10
        product.stockQuantity = 5
        product.lowStockThreshold = 0
        product.overstockThreshold = 0
        product.defaultDeveloperRatio = 1
        product.developerStrength = 0
        product.recommendedDeveloperStrength = 0
        product.createdAt = .now
        product.updatedAt = .now
        product.autoAddDisabled = false

        let selection = FormulaSelection(
            product: product,
            amountUsed: 1,
            ratioPart: 1,
            deductionMode: .newUnit
        )

        let deduction = FormulaDeductionCalculator.deductionAmount(for: selection)
        XCTAssertEqual(deduction, 2, accuracy: 0.001)
    }

    func testOpenStockDeductionUsesAmount() {
        let context = PersistenceController(inMemory: true).viewContext
        let product = Product(context: context)
        product.id = UUID()
        product.name = "Color"
        product.brand = "Brand"
        product.productType = .permanent
        product.unit = .ounces
        product.quantityPerUnit = 2
        product.purchasePrice = 10
        product.stockQuantity = 5
        product.lowStockThreshold = 0
        product.overstockThreshold = 0
        product.defaultDeveloperRatio = 1
        product.developerStrength = 0
        product.recommendedDeveloperStrength = 0
        product.createdAt = .now
        product.updatedAt = .now
        product.autoAddDisabled = false

        let selection = FormulaSelection(
            product: product,
            amountUsed: 1.25,
            ratioPart: 1,
            deductionMode: .openStock
        )

        let deduction = FormulaDeductionCalculator.deductionAmount(for: selection)
        XCTAssertEqual(deduction, 1.25, accuracy: 0.001)
    }
}
