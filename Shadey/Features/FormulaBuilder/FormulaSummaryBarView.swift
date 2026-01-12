import SwiftUI

struct FormulaSummaryBarView: View {
    let formulaCount: Int
    let totalMixAmount: Double
    let unitLabel: String
    let showsMixedUnits: Bool
    let totalCost: Double

    var body: some View {
        let amountText = showsMixedUnits
            ? "Mixed units"
            : "\(totalMixAmount.formatted(.number.precision(.fractionLength(2)))) \(unitLabel)"

        HStack(alignment: .center, spacing: DesignSystem.Spacing.medium) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                Text("Formulas")
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.textSecondary)
                Text("\(formulaCount)")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textPrimary)
            }
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                Text("Total Mix")
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.textSecondary)
                Text(amountText)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textPrimary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xSmall) {
                Text("Total")
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.textSecondary)
                Text(totalCost, format: CurrencyFormat.inventory)
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
            }
        }
        .padding(DesignSystem.Spacing.medium)
        .background(DesignSystem.secondarySurface)
        .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.medium))
        .overlay(
            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                .stroke(DesignSystem.stroke, lineWidth: 1)
        )
    }
}
