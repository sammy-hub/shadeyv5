import CoreData
import XCTest
@testable import Shadey

@MainActor
final class ShoppingListStoreTests: XCTestCase {
    private var context: NSManagedObjectContext!
    private var shoppingListStore: ShoppingListStore!
    private var inventoryStore: InventoryStore!
    private var stockAlertSettingsStore: StockAlertSettingsStore!
    private var preferencesStore: ShoppingListPreferencesStore!

    override func setUp() {
        super.setUp()
        let persistence = PersistenceController(inMemory: true)
        context = persistence.viewContext
        stockAlertSettingsStore = StockAlertSettingsStore()
        preferencesStore = ShoppingListPreferencesStore()
        shoppingListStore = ShoppingListStore(
            context: context,
            stockAlertSettingsStore: stockAlertSettingsStore,
            preferencesStore: preferencesStore
        )
        inventoryStore = InventoryStore(
            context: context,
            shoppingListStore: shoppingListStore,
            productTypeStore: ProductTypeStore()
        )
    }

    override func tearDown() {
        context = nil
        shoppingListStore = nil
        inventoryStore = nil
        stockAlertSettingsStore = nil
        preferencesStore = nil
        super.tearDown()
    }

    func testAutoAddLowStockAddsItem() throws {
        let product = makeProduct(name: "Color", stock: 2)
        stockAlertSettingsStore.typeThresholds[product.resolvedProductTypeId] = 3
        try context.save()
        inventoryStore.reload()

        shoppingListStore.updateAutoList(for: product)

        XCTAssertEqual(shoppingListStore.items.count, 1)
        XCTAssertEqual(shoppingListStore.items.first?.reason, .lowStock)
    }

    func testAutoAddRemovesWhenStockRecovers() throws {
        let product = makeProduct(name: "Color", stock: 1)
        stockAlertSettingsStore.typeThresholds[product.resolvedProductTypeId] = 3
        try context.save()
        inventoryStore.reload()

        shoppingListStore.updateAutoList(for: product)
        XCTAssertEqual(shoppingListStore.items.count, 1)

        product.stockQuantity = 5
        shoppingListStore.updateAutoList(for: product)

        XCTAssertEqual(shoppingListStore.items.count, 0)
    }

    func testManualItemPersistsWhenAutoListUpdates() throws {
        let product = makeProduct(name: "Color", stock: 5)
        try context.save()
        inventoryStore.reload()

        shoppingListStore.addManualItem(for: product, quantity: 2, note: nil)
        XCTAssertEqual(shoppingListStore.items.count, 1)
        XCTAssertEqual(shoppingListStore.items.first?.reason, .manual)

        product.stockQuantity = 10
        shoppingListStore.updateAutoList(for: product)

        XCTAssertEqual(shoppingListStore.items.count, 1)
        XCTAssertEqual(shoppingListStore.items.first?.reason, .manual)
    }

    private func makeProduct(name: String, stock: Double) -> Product {
        let product = Product(context: context)
        product.id = UUID()
        product.name = name
        product.brand = "Brand"
        product.productType = .permanent
        product.unit = .ounces
        product.quantityPerUnit = 2
        product.purchasePrice = 10
        product.stockQuantity = stock
        product.lowStockThreshold = 0
        product.overstockThreshold = 0
        product.defaultDeveloperRatio = 1
        product.developerStrength = 0
        product.recommendedDeveloperStrength = 0
        product.createdAt = .now
        product.updatedAt = .now
        product.autoAddDisabled = false
        return product
    }
}
