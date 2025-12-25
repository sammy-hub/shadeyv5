import SwiftUI

struct InventorySummaryCardView: View {
    let totalValue: Double
    let lowStockCount: Int
    let overstockCount: Int

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Total Inventory Value")
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Text(totalValue, format: CurrencyFormat.inventory)
                    .font(DesignSystem.Typography.titleEmphasis)
                    .bold()
                    .foregroundStyle(DesignSystem.textPrimary)
                HStack {
                    StatusPillView(title: "Low", value: lowStockCount, color: DesignSystem.warning)
                    StatusPillView(title: "Overstock", value: overstockCount, color: DesignSystem.positive)
                }
            }
        }
    }
}
