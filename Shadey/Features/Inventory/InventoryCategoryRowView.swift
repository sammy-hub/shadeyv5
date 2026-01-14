import SwiftUI

struct InventoryCategoryRowView: View {
    let summary: InventoryCategorySummary

    var body: some View {
        let lineLabel = summary.category == .hairColor ? "lines" : "groups"
        let subtitle = "\(summary.productCount) items • \(summary.lineCount) \(lineLabel)"

        ListRowView(
            systemImage: summary.category.systemImage,
            title: summary.category.displayName,
            subtitle: subtitle
        ) {
            HStack(spacing: 8) {
                if summary.lowStockCount > 0 {
                    StockStatusBadgeView(status: .low)
                }
                Text(summary.totalValue.formatted(AppFormatters.currency))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
