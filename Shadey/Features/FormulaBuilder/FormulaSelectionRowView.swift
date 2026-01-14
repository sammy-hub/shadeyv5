import SwiftUI

struct FormulaSelectionRowView: View {
    let selection: FormulaSelection
    let unitLabel: String
    @Binding var amount: Double?
    @Binding var ratioPart: Double
    @Binding var deductionMode: InventoryDeductionMode

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                Text(selection.product.displayName)
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Text("\(selection.product.resolvedBrand) • \(selection.product.shadeLabel)")
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.textSecondary)
            }

            HStack(alignment: .firstTextBaseline, spacing: DesignSystem.Spacing.small) {
                Text("Amount")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
                Spacer()
                OptionalNumberField(
                    "",
                    value: $amount,
                    format: .number,
                    keyboardType: .decimalPad,
                    accessibilityLabel: "Amount"
                )
                .multilineTextAlignment(.trailing)
                .frame(width: 90)
                Text(unitLabel)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }

            HStack(alignment: .firstTextBaseline, spacing: DesignSystem.Spacing.small) {
                Text("Ratio")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
                Spacer()
                TextField("Parts", value: $ratioPart, format: .number)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .frame(width: 90)
                Text(": 1")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }

            Picker("Deduct", selection: $deductionMode) {
                ForEach(InventoryDeductionMode.allCases) { mode in
                    Text(mode.displayName)
                        .tag(mode)
                }
            }
            .pickerStyle(.menu)

            Text(selection.cost, format: CurrencyFormat.inventory)
                .font(DesignSystem.Typography.caption)
                .foregroundStyle(DesignSystem.textSecondary)
        }
        .padding(.vertical, DesignSystem.Spacing.xSmall)
    }
}
