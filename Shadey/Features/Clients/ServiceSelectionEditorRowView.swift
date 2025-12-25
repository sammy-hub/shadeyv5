import SwiftUI

struct ServiceSelectionEditorRowView: View {
    let selection: FormulaSelection
    @Binding var amount: Double?
    @Binding var ratioPart: Double

    var body: some View {
        VStack(alignment: .leading) {
            Text(selection.product.displayName)
                .font(DesignSystem.Typography.headline)
                .foregroundStyle(DesignSystem.textPrimary)
            HStack {
                FieldContainerView {
                    OptionalNumberField("Amount", value: $amount, format: .number)
                }
                Text(selection.product.resolvedUnit.displayName)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
            HStack {
                FieldContainerView {
                    TextField("Ratio Part", value: $ratioPart, format: .number)
                        .keyboardType(.decimalPad)
                }
                Text("part")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
            Text(selection.cost, format: CurrencyFormat.inventory)
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(DesignSystem.textSecondary)
        }
        .padding(.vertical, DesignSystem.Spacing.small)
    }
}
