import SwiftUI

struct SettingsView: View {
    @State private var viewModel: SettingsViewModel
    let productTypeStore: ProductTypeStore

    init(viewModel: SettingsViewModel, productTypeStore: ProductTypeStore) {
        _viewModel = State(initialValue: viewModel)
        self.productTypeStore = productTypeStore
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

            Section("Inventory") {
                NavigationLink("Product Types") {
                    ProductTypeManagerView(store: productTypeStore)
                }
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
