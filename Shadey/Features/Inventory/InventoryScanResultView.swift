import SwiftUI

struct InventoryScanResultView: View {
    let store: InventoryStore
    let product: Product
    let scannedCode: String
    let onDone: () -> Void

    @State private var adjustmentType: AdjustmentType = .add
    @State private var amount: Double? = 1

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Match Found")
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Text(product.displayName)
                    .font(DesignSystem.Typography.title)
                    .bold()
                    .foregroundStyle(DesignSystem.textPrimary)
                Text("Barcode: \(scannedCode)")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)

                Picker("Action", selection: $adjustmentType) {
                    ForEach(AdjustmentType.allCases) { type in
                        Text(type.displayName)
                            .tag(type)
                    }
                }
                .pickerStyle(.segmented)

                FieldContainerView {
                    OptionalNumberField("Amount", value: $amount, format: .number)
                }

                Button("Apply") {
                    guard let amount else { return }
                    store.adjustStock(for: product, by: amount * adjustmentType.multiplier)
                    onDone()
                }
                .buttonStyle(.borderedProminent)
                .disabled((amount ?? 0) <= 0)
            }
        }
    }
}
