import CoreData
import XCTest
@testable import Shadey

@MainActor
final class ClientsStoreDeductionTests: XCTestCase {
    func testServiceDeductsUsingDeductionMode() throws {
        let persistence = PersistenceController(inMemory: true)
        let context = persistence.viewContext
        let stockAlertSettingsStore = StockAlertSettingsStore()
        let preferencesStore = ShoppingListPreferencesStore()
        let shoppingListStore = ShoppingListStore(
            context: context,
            stockAlertSettingsStore: stockAlertSettingsStore,
            preferencesStore: preferencesStore
        )
        let inventoryStore = InventoryStore(
            context: context,
            shoppingListStore: shoppingListStore,
            productTypeStore: ProductTypeStore()
        )
        let clientsStore = ClientsStore(context: context, inventoryStore: inventoryStore)

        let product = Product(context: context)
        product.id = UUID()
        product.name = "Color"
        product.brand = "Brand"
        product.productType = .permanent
        product.unit = .ounces
        product.quantityPerUnit = 2
        product.purchasePrice = 10
        product.stockQuantity = 10
        product.lowStockThreshold = 0
        product.overstockThreshold = 0
        product.defaultDeveloperRatio = 1
        product.developerStrength = 0
        product.recommendedDeveloperStrength = 0
        product.createdAt = .now
        product.updatedAt = .now
        product.autoAddDisabled = false

        let client = Client(context: context)
        client.id = UUID()
        client.name = "Client"
        client.createdAt = .now

        try context.save()
        inventoryStore.reload()
        clientsStore.reload()

        let selection = FormulaSelection(
            product: product,
            amountUsed: 1,
            ratioPart: 1,
            deductionMode: .newUnit
        )
        let formula = ServiceFormulaDraft(name: "Formula 1", selections: [selection], developer: nil, developerRatio: 1)
        let draft = ServiceDraft(formulas: [formula])
        clientsStore.addService(to: client, draft: draft)

        let updated = inventoryStore.product(id: product.id)
        XCTAssertEqual(updated?.stockQuantity, 8, accuracy: 0.001)
    }
}
