import SwiftUI

struct SettingsView: View {
    @State private var viewModel: SettingsViewModel
    let productTypeStore: ProductTypeStore
    let inventoryStore: InventoryStore
    @Bindable var shoppingListPreferencesStore: ShoppingListPreferencesStore
    let stockAlertSettingsStore: StockAlertSettingsStore
    @Bindable var appearanceSettings: AppearanceSettings

    init(
        viewModel: SettingsViewModel,
        productTypeStore: ProductTypeStore,
        inventoryStore: InventoryStore,
        shoppingListPreferencesStore: ShoppingListPreferencesStore,
        stockAlertSettingsStore: StockAlertSettingsStore,
        appearanceSettings: AppearanceSettings
    ) {
        _viewModel = State(initialValue: viewModel)
        self.productTypeStore = productTypeStore
        self.inventoryStore = inventoryStore
        self.shoppingListPreferencesStore = shoppingListPreferencesStore
        self.stockAlertSettingsStore = stockAlertSettingsStore
        self.appearanceSettings = appearanceSettings
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        return Form {
            Section("Profile") {
                TextField("Name", text: $viewModel.profileName)
                TextField("Salon", text: $viewModel.salonName)
            }

            Section("Preferences") {
                Picker("Preferred Unit", selection: $viewModel.preferredUnitRaw) {
                    ForEach(UnitType.allCases) { unit in
                        Text(unit.displayName)
                            .tag(unit.rawValue)
                    }
                }
                Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
            }

            Section("Appearance") {
                Picker("Theme", selection: $appearanceSettings.themePreference) {
                    ForEach(AppearanceSettings.ThemePreference.allCases) { preference in
                        Text(preference.displayName)
                            .tag(preference)
                    }
                }
                .pickerStyle(.menu)

                Picker("Accent Color", selection: $appearanceSettings.accentSelection) {
                    ForEach(AppearanceSettings.AccentSelection.allCases) { selection in
                        Label(selection.displayName, systemImage: "circle.fill")
                            .foregroundStyle(selection.color)
                            .tag(selection)
                    }
                }
                .pickerStyle(.menu)
            }

            Section("Inventory") {
                NavigationLink("Product Types") {
                    ProductTypeManagerView(store: productTypeStore)
                }
                NavigationLink("Color Lines") {
                    ColorLineManagerView(store: inventoryStore)
                }
                NavigationLink("Stock Alerts") {
                    StockAlertSettingsView(
                        stockAlertSettingsStore: stockAlertSettingsStore,
                        productTypeStore: productTypeStore,
                        inventoryStore: inventoryStore
                    )
                }
            }

            Section("Shopping List") {
                Toggle("Auto-restock on purchase", isOn: $shoppingListPreferencesStore.autoRestockOnPurchase)
            }

            Section {
                Text("Shadey stores inventory and formulas locally on this device.")
                    .font(.footnote)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
        }
        .navigationTitle("Settings")
    }
}
