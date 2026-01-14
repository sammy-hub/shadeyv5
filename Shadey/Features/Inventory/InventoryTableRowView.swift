import SwiftUI

struct InventoryTableRowView: View {
    let title: String
    let subtitle: String
    let stockText: String
    let unitCostText: String?
    let stockStatus: StockStatus

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .top, spacing: DesignSystem.Spacing.medium) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                    Text(title)
                        .font(DesignSystem.Typography.headline)
                        .foregroundStyle(DesignSystem.textPrimary)
                    Text(subtitle)
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xSmall) {
                    Text(stockText)
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundStyle(DesignSystem.textPrimary)
                    if stockStatus != .normal {
                        StockStatusBadgeView(status: stockStatus)
                    }
                }
                VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xSmall) {
                    if let unitCostText {
                        Text(unitCostText)
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.textPrimary)
                    } else {
                        Text("—")
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                }
                .frame(width: 90, alignment: .trailing)
            }

            HStack(alignment: .top, spacing: DesignSystem.Spacing.medium) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                    Text(title)
                        .font(DesignSystem.Typography.headline)
                        .foregroundStyle(DesignSystem.textPrimary)
                    Text(subtitle)
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xSmall) {
                    Text(stockText)
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundStyle(DesignSystem.textPrimary)
                    if stockStatus != .normal {
                        StockStatusBadgeView(status: stockStatus)
                    }
                }
            }
        }
        .padding(.vertical, DesignSystem.Spacing.xSmall)
        .accessibilityElement(children: .combine)
    }
}
