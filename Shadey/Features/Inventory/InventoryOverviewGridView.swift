import SwiftUI

struct InventoryOverviewGridView: View {
    let totalValue: Double
    let shadeCount: Int
    let lowStockCount: Int
    let overstockCount: Int

    private let columns = [
        GridItem(.flexible(), spacing: DesignSystem.Spacing.medium),
        GridItem(.flexible(), spacing: DesignSystem.Spacing.medium)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: DesignSystem.Spacing.medium) {
            InventoryOverviewCardView(
                title: "Total Value",
                value: totalValue.formatted(CurrencyFormat.inventory),
                accentColor: DesignSystem.textPrimary
            )
            InventoryOverviewCardView(
                title: "Shades",
                value: shadeCount.formatted(.number),
                accentColor: DesignSystem.textPrimary
            )
            InventoryOverviewCardView(
                title: "Low Stock",
                value: lowStockCount.formatted(.number),
                accentColor: DesignSystem.warning
            )
            InventoryOverviewCardView(
                title: "Overstock",
                value: overstockCount.formatted(.number),
                accentColor: DesignSystem.positive
            )
        }
    }
}
