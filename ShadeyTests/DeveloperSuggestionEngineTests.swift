import CoreData
import XCTest
@testable import Shadey

@MainActor
final class DeveloperSuggestionEngineTests: XCTestCase {
    func testUsesLineDefaultDeveloperWhenAvailable() {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.viewContext
        let stockAlertSettingsStore = StockAlertSettingsStore()
        let preferencesStore = ShoppingListPreferencesStore()
        let shoppingListStore = ShoppingListStore(
            context: context,
            stockAlertSettingsStore: stockAlertSettingsStore,
            preferencesStore: preferencesStore
        )
        let productTypeStore = ProductTypeStore()
        let inventoryStore = InventoryStore(
            context: context,
            shoppingListStore: shoppingListStore,
            productTypeStore: productTypeStore
        )

        let developer = Product(context: context)
        developer.id = UUID()
        developer.name = "Developer"
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

        let line = ColorLine(context: context)
        line.id = UUID()
        line.brand = "Brand"
        line.name = "Line"
        line.defaultProductTypeRaw = ProductType.permanent.rawValue
        line.defaultUnit = .ounces
        line.defaultQuantityPerUnit = 2
        line.defaultPurchasePrice = 10
        line.defaultDeveloperRatio = 1.0
        line.defaultDeveloper = developer
        line.createdAt = .now
        line.updatedAt = .now

        let color = Product(context: context)
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
        color.defaultDeveloperRatio = 1
        color.developerStrength = 0
        color.recommendedDeveloperStrength = 0
        color.createdAt = .now
        color.updatedAt = .now
        color.autoAddDisabled = false
        color.colorLine = line

        try? context.save()
        inventoryStore.reload()

        let selection = FormulaSelection(product: color, amountUsed: 1, ratioPart: 1)
        let suggestion = DeveloperSuggestionEngine.suggestion(
            for: [selection],
            inventoryStore: inventoryStore,
            productTypeStore: productTypeStore
        )

        XCTAssertEqual(suggestion.developer?.id, developer.id)
        XCTAssertEqual(suggestion.source, .lineDefault)
    }
}
