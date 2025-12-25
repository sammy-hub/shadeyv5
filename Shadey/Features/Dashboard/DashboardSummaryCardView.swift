import SwiftUI

struct DashboardSummaryCardView: View {
    let totalValue: Double
    let lowStock: Int
    let overstock: Int

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Inventory Overview")
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Text(totalValue, format: CurrencyFormat.inventory)
                    .font(DesignSystem.Typography.titleEmphasis)
                    .bold()
                    .foregroundStyle(DesignSystem.textPrimary)
                HStack {
                    StatusPillView(title: "Low stock", value: lowStock, color: DesignSystem.warning)
                    StatusPillView(title: "Overstock", value: overstock, color: DesignSystem.positive)
                }
            }
        }
    }
}
