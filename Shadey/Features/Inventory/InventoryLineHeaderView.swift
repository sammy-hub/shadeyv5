import SwiftUI

struct InventoryLineHeaderView: View {
    let section: InventoryLineSection
    let itemLabel: String

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
            Text(section.displaySubtitle)
                .font(DesignSystem.Typography.caption)
                .foregroundStyle(DesignSystem.textSecondary)
            Text(section.displayTitle)
                .font(DesignSystem.Typography.headline)
                .foregroundStyle(DesignSystem.textPrimary)

            HStack(spacing: DesignSystem.Spacing.small) {
                Text("\(section.shadeCount) \(itemLabel)")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
                Spacer()
                if section.lowStockCount > 0 {
                    StatusPillView(title: "Low", value: section.lowStockCount, color: DesignSystem.warning)
                }
                if section.overstockCount > 0 {
                    StatusPillView(title: "Over", value: section.overstockCount, color: DesignSystem.positive)
                }
            }
        }
    }
}
