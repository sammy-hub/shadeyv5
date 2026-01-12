import SwiftUI

struct StockAlertSettingsView: View {
    @Bindable var stockAlertSettingsStore: StockAlertSettingsStore
    let productTypeStore: ProductTypeStore
    let inventoryStore: InventoryStore

    var body: some View {
        let brands = inventoryStore.products
            .map(\.resolvedBrand)
            .reduce(into: Set<String>()) { $0.insert($1) }
            .sorted { $0.localizedStandardCompare($1) == .orderedAscending }

        return Form {
            Section("By Product Type") {
                ForEach(productTypeStore.allDefinitions) { type in
                    StockAlertThresholdRowView(
                        title: type.name,
                        threshold: bindingForType(type)
                    )
                }
            }

            Section("By Brand") {
                if brands.isEmpty {
                    Text("Add inventory to set brand thresholds.")
                        .font(.subheadline)
                        .foregroundStyle(DesignSystem.textSecondary)
                } else {
                    ForEach(brands, id: \.self) { brand in
                        StockAlertThresholdRowView(
                            title: brand,
                            threshold: bindingForBrand(brand)
                        )
                    }
                }
            }
        }
        .navigationTitle("Stock Alerts")
    }

    private func bindingForType(_ type: ProductTypeDefinition) -> Binding<Double?> {
        Binding(
            get: { stockAlertSettingsStore.typeThresholds[type.id] },
            set: { newValue in
                if let newValue, newValue > 0 {
                    stockAlertSettingsStore.typeThresholds[type.id] = newValue
                } else {
                    stockAlertSettingsStore.typeThresholds.removeValue(forKey: type.id)
                }
            }
        )
    }

    private func bindingForBrand(_ brand: String) -> Binding<Double?> {
        Binding(
            get: { stockAlertSettingsStore.brandThresholds[brand] },
            set: { newValue in
                if let newValue, newValue > 0 {
                    stockAlertSettingsStore.brandThresholds[brand] = newValue
                } else {
                    stockAlertSettingsStore.brandThresholds.removeValue(forKey: brand)
                }
            }
        )
    }
}

struct StockAlertThresholdRowView: View {
    let title: String
    @Binding var threshold: Double?

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(DesignSystem.textPrimary)
            OptionalNumberField("Threshold", value: $threshold, format: .number)
                .font(.subheadline)
        }
        .padding(.vertical, DesignSystem.Spacing.xSmall)
    }
}
