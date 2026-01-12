import SwiftUI

struct InventoryLineRowView: View {
    let section: InventoryLineSection
    let isExpanded: Bool
    let itemLabel: String
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .fill(DesignSystem.surface)

                Rectangle()
                    .fill(fillColor.opacity(fillOpacity))
                    .scaleEffect(x: section.fillRatio, anchor: .leading)
                    .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.large))

                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    HStack(alignment: .top) {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                            Text(section.displaySubtitle)
                                .font(DesignSystem.Typography.caption)
                                .foregroundStyle(DesignSystem.textSecondary)
                            Text(section.displayTitle)
                                .font(DesignSystem.Typography.headline)
                                .foregroundStyle(DesignSystem.textPrimary)
                            Text("\(section.shadeCount) \(itemLabel)")
                                .font(DesignSystem.Typography.subheadline)
                                .foregroundStyle(DesignSystem.textSecondary)
                        }
                        Spacer()
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                            .foregroundStyle(DesignSystem.textSecondary)
                    }

                    HStack {
                        Text(stockSummaryText)
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.textPrimary)
                        Spacer()
                        if section.lowStockCount > 0 {
                            StatusPillView(title: "Low", value: section.lowStockCount, color: DesignSystem.warning)
                        }
                        if section.overstockCount > 0 {
                            StatusPillView(title: "Over", value: section.overstockCount, color: DesignSystem.positive)
                        }
                    }
                }
                .padding(DesignSystem.Spacing.cardPadding)
            }
            .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.large))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .stroke(DesignSystem.stroke, lineWidth: 1)
            )
            .shadow(color: DesignSystem.stroke.opacity(0.4), radius: 10, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }

    private var fillColor: Color {
        if section.lowStockCount > 0 {
            return DesignSystem.warning
        }
        return DesignSystem.positive
    }

    private var fillOpacity: Double {
        if section.fillRatio == 0 {
            return 0
        }
        return 0.12 + (0.35 * section.fillRatio)
    }

    private var stockSummaryText: String {
        let total = section.shadeCount
        if total == 0 {
            return "No items yet"
        }
        let inStock = section.inStockCount
        if inStock == 0 {
            return "\(total) \(itemLabel) out of stock"
        }
        if inStock == total {
            return "All \(total) \(itemLabel) in stock"
        }
        return "\(inStock) of \(total) \(itemLabel) in stock"
    }
}
