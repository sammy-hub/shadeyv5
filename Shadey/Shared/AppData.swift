import Foundation
import Observation

@MainActor
@Observable
final class AppData {
    let persistence: PersistenceController
    let productTypeStore: ProductTypeStore
    let inventoryStore: InventoryStore
    let clientsStore: ClientsStore
    let shoppingListStore: ShoppingListStore
    let shoppingListPreferencesStore: ShoppingListPreferencesStore
    let stockAlertSettingsStore: StockAlertSettingsStore
    let formulaBuilderPreferencesStore: FormulaBuilderPreferencesStore
    let onboardingStore: OnboardingStore
    let appearanceSettings: AppearanceSettings

    init(persistence: PersistenceController = .shared) {
        self.persistence = persistence
        self.productTypeStore = ProductTypeStore()
        self.shoppingListPreferencesStore = ShoppingListPreferencesStore()
        self.stockAlertSettingsStore = StockAlertSettingsStore()
        self.formulaBuilderPreferencesStore = FormulaBuilderPreferencesStore()
        self.onboardingStore = OnboardingStore()
        self.appearanceSettings = AppearanceSettings()
        let context = persistence.viewContext
        let shoppingListStore = ShoppingListStore(
            context: context,
            stockAlertSettingsStore: stockAlertSettingsStore,
            preferencesStore: shoppingListPreferencesStore
        )
        self.shoppingListStore = shoppingListStore
        let inventoryStore = InventoryStore(
            context: context,
            shoppingListStore: shoppingListStore,
            productTypeStore: productTypeStore
        )
        self.inventoryStore = inventoryStore
        self.clientsStore = ClientsStore(context: context, inventoryStore: inventoryStore)
    }
}
