import SwiftUI

struct RootTabView: View {
    @Bindable var appData: AppData

    init(appData: AppData) {
        self.appData = appData
    }

    var body: some View {
        TabView {
            Tab("Dashboard", systemImage: "chart.bar") {
                NavigationStack {
                    DashboardView(
                        viewModel: DashboardViewModel(
                            inventoryStore: appData.inventoryStore,
                            clientsStore: appData.clientsStore
                        )
                    )
                }
            }
            Tab("Inventory", systemImage: "tray.full") {
                NavigationStack {
                    InventoryView(
                        viewModel: InventoryViewModel(
                            store: appData.inventoryStore,
                            stockAlertSettingsStore: appData.stockAlertSettingsStore
                        )
                    )
                }
            }
            Tab("Clients", systemImage: "person.2") {
                NavigationStack {
                    ClientsView(viewModel: ClientsViewModel(store: appData.clientsStore), inventoryStore: appData.inventoryStore)
                }
            }
            Tab("Shopping", systemImage: "checklist") {
                NavigationStack {
                    ShoppingListView(
                        viewModel: ShoppingListViewModel(
                            store: appData.shoppingListStore,
                            inventoryStore: appData.inventoryStore,
                            preferencesStore: appData.shoppingListPreferencesStore,
                            stockAlertSettingsStore: appData.stockAlertSettingsStore
                        )
                    )
                }
            }
            Tab("Settings", systemImage: "gearshape") {
                NavigationStack {
                    SettingsView(
                        viewModel: SettingsViewModel(),
                        productTypeStore: appData.productTypeStore,
                        inventoryStore: appData.inventoryStore,
                        shoppingListPreferencesStore: appData.shoppingListPreferencesStore,
                        stockAlertSettingsStore: appData.stockAlertSettingsStore,
                        appearanceSettings: appData.appearanceSettings
                    )
                }
            }
        }
        .tint(appData.appearanceSettings.accentColor)
        .preferredColorScheme(appData.appearanceSettings.preferredColorScheme)
    }
}

#Preview {
    RootTabView(appData: AppData())
}

