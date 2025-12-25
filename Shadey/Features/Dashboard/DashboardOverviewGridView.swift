import SwiftUI

struct DashboardOverviewGridView: View {
    let totalValue: Double
    let clientCount: Int
    let lowStockCount: Int
    let overstockCount: Int

    private let columns = [
        GridItem(.flexible(), spacing: DesignSystem.Spacing.medium),
        GridItem(.flexible(), spacing: DesignSystem.Spacing.medium)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: DesignSystem.Spacing.medium) {
            DashboardOverviewCardView(
                title: "Inventory Value",
                value: totalValue.formatted(CurrencyFormat.inventory),
                accentColor: DesignSystem.textPrimary
            )
            DashboardOverviewCardView(
                title: "Clients",
                value: clientCount.formatted(.number),
                accentColor: DesignSystem.textPrimary
            )
            DashboardOverviewCardView(
                title: "Low Stock",
                value: lowStockCount.formatted(.number),
                accentColor: DesignSystem.warning
            )
            DashboardOverviewCardView(
                title: "Overstock",
                value: overstockCount.formatted(.number),
                accentColor: DesignSystem.positive
            )
        }
    }
}
