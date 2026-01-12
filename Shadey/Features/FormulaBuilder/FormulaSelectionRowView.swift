import SwiftUI

struct FormulaSelectionRowView: View {
    let selection: FormulaSelection
    let unitLabel: String
    @Binding var amount: Double?
    @Binding var ratioPart: Double
    let onRemove: () -> Void
    
    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                        Text(selection.product.displayName)
                            .font(DesignSystem.Typography.headline)
                            .foregroundStyle(DesignSystem.textPrimary)
                        Text(selection.product.resolvedBrand)
                            .font(DesignSystem.Typography.caption)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                    Spacer()
                    Button("Remove", systemImage: "trash") {
                        onRemove()
                    }
                    .buttonStyle(.bordered)
                }
                
                NumberEntryRow(
                    "Amount",
                    helper: "How much of this product is included in the mix.",
                    unitLabel: unitLabel,
                    value: $amount,
                    format: .number
                )
                
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                    Text("Developer ratio")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                    Text("Parts of developer for every 1 part of this product.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                    HStack(spacing: DesignSystem.Spacing.small) {
                        TextField("Parts", value: $ratioPart, format: .number)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                            .frame(minWidth: 70)
                        Text("parts")
                            .font(DesignSystem.Typography.caption)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                }
                
                Text(selection.cost, format: CurrencyFormat.inventory)
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
        }
    }
}
