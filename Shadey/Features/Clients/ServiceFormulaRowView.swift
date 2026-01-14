import SwiftUI

struct ServiceFormulaRowView: View {
    let name: String
    let productCount: Int
    let mixAmount: Double
    let unitLabel: String
    let totalCost: Double

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
            Text(name)
                .font(DesignSystem.Typography.headline)
                .foregroundStyle(DesignSystem.textPrimary)

            Text("\(productCount) \(productCount == 1 ? "product" : "products")")
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(DesignSystem.textSecondary)

            HStack {
                Text("\(mixAmount.formatted(.number.precision(.fractionLength(2)))) \(unitLabel)")
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.textSecondary)
                Spacer()
                Text(totalCost, format: CurrencyFormat.inventory)
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
        }
        .accessibilityElement(children: .combine)
    }
}
