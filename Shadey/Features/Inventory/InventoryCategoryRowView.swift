import SwiftUI

struct InventoryCategoryRowView: View {
    let summary: InventoryCategorySummary

    var body: some View {
        let lineLabel = summary.category == .hairColor ? "lines" : "groups"

        SurfaceCardView {
            HStack(alignment: .center, spacing: DesignSystem.Spacing.medium) {
                Image(systemName: summary.category.systemImage)
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                    Text(summary.category.displayName)
                        .font(DesignSystem.Typography.headline)
                        .foregroundStyle(DesignSystem.textPrimary)
                    Text("\(summary.productCount) items | \(summary.lineCount) \(lineLabel)")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xSmall) {
                    Text("Value")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                    Text(summary.totalValue, format: CurrencyFormat.inventory)
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundStyle(DesignSystem.textPrimary)
                }

                if summary.lowStockCount > 0 {
                    StatusPillView(title: "Low", value: summary.lowStockCount, color: DesignSystem.warning)
                }
            }
        }
    }
}
