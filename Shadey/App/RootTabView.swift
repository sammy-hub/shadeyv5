import SwiftUI

struct RootTabView: View {
    let appData: AppData

    var body: some View {
        TabView {
            Tab("Dashboard", systemImage: "chart.bar") {
                NavigationStack {
                    DashboardView(viewModel: DashboardViewModel(inventoryStore: appData.inventoryStore, clientsStore: appData.clientsStore))
                }
            }
            Tab("Inventory", systemImage: "tray.full") {
                NavigationStack {
                    InventoryView(viewModel: InventoryViewModel(store: appData.inventoryStore))
                }
            }
            Tab("Clients", systemImage: "person.2") {
                NavigationStack {
                    ClientsView(viewModel: ClientsViewModel(store: appData.clientsStore), inventoryStore: appData.inventoryStore)
                }
            }
            Tab("Shopping", systemImage: "checklist") {
                NavigationStack {
                    ShoppingListView(viewModel: ShoppingListViewModel(store: appData.shoppingListStore))
                }
            }
            Tab("Settings", systemImage: "gearshape") {
                NavigationStack {
                    SettingsView(viewModel: SettingsViewModel(), productTypeStore: appData.productTypeStore)
                }
            }
        }
        .tint(DesignSystem.accent)
    }
}
