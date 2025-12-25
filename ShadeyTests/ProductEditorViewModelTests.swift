import CoreData
import XCTest
@testable import Shadey

@MainActor
final class ProductEditorViewModelTests: XCTestCase {
    private var context: NSManagedObjectContext!
    private var inventoryStore: InventoryStore!
    private var shoppingListStore: ShoppingListStore!

    override func setUp() {
        super.setUp()
        let persistence = PersistenceController(inMemory: true)
        context = persistence.viewContext
        shoppingListStore = ShoppingListStore(context: context)
        inventoryStore = InventoryStore(
            context: context,
            shoppingListStore: shoppingListStore,
            productTypeStore: ProductTypeStore()
        )
        UserDefaults.standard.removeObject(forKey: "pinnedBrands")
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: "pinnedBrands")
        context = nil
        inventoryStore = nil
        shoppingListStore = nil
        super.tearDown()
    }

    func testSaveEnabledRequiresBrandAndName() {
        let viewModel = ProductEditorViewModel(store: inventoryStore)
        XCTAssertFalse(viewModel.isSaveEnabled)

        viewModel.draft.brand = "Redken"
        XCTAssertFalse(viewModel.isSaveEnabled)

        viewModel.draft.name = "6N"
        XCTAssertTrue(viewModel.isSaveEnabled)
    }

    func testBrandSuggestionsMatchQuery() throws {
        makeProduct(brand: "Redken", name: "6N")
        makeProduct(brand: "Wella", name: "7A")
        try context.save()
        inventoryStore.reload()

        let viewModel = ProductEditorViewModel(store: inventoryStore)
        viewModel.draft.brand = "red"

        XCTAssertTrue(viewModel.brandSuggestions.contains("Redken"))
        XCTAssertFalse(viewModel.brandSuggestions.contains("Wella"))
    }

    func testShadeSuggestionsRespectBrand() throws {
        makeProduct(brand: "Redken", name: "6N")
        makeProduct(brand: "Wella", name: "7A")
        try context.save()
        inventoryStore.reload()

        let viewModel = ProductEditorViewModel(store: inventoryStore)
        viewModel.draft.brand = "Redken"

        XCTAssertEqual(viewModel.shadeSuggestions, ["6N"])
    }

    private func makeProduct(brand: String, name: String) -> Product {
        let product = Product(context: context)
        product.id = UUID()
        product.name = name
        product.brand = brand
        product.productType = .permanent
        product.unit = .ounces
        product.quantityPerUnit = 1
        product.purchasePrice = 10
        product.stockQuantity = 2
        product.lowStockThreshold = 0
        product.overstockThreshold = 0
        product.defaultDeveloperRatio = 1
        product.developerStrength = 0
        product.recommendedDeveloperStrength = 0
        product.createdAt = .now
        product.updatedAt = .now
        return product
    }
}
