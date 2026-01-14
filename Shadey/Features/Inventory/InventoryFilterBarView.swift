import SwiftUI

struct InventoryFilterBarView: View {
    @Bindable var viewModel: InventoryViewModel

    var body: some View {
        Section {
            if viewModel.availableBrands.isEmpty {
                Text("Brands appear after your first product.")
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.textSecondary)
            } else {
                Picker("Brand", selection: $viewModel.selectedBrand) {
                    Text("All Brands").tag(nil as String?)
                    ForEach(viewModel.availableBrands, id: \.self) { brand in
                        Text(brand)
                            .tag(Optional(brand))
                    }
                }
                .pickerStyle(.menu)
            }

            if viewModel.availableTypes.isEmpty {
                Text("Product types appear after your first entry.")
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.textSecondary)
            } else {
                Picker("Type", selection: $viewModel.selectedTypeId) {
                    Text("All Types").tag(nil as String?)
                    ForEach(viewModel.availableTypes) { type in
                        Text(type.name)
                            .tag(Optional(type.id))
                    }
                }
                .pickerStyle(.menu)
            }

            if viewModel.hasActiveFilters {
                Button("Clear Filters", systemImage: "xmark.circle") {
                    viewModel.clearFilters()
                }
                .accessibilityIdentifier("clearInventoryFiltersButton")
            }
        } header: {
            Text("Filters")
        } footer: {
            Text("Filter by brand or product type.")
        }
    }
}
