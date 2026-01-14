import SwiftUI

#Preview {
    VStack(spacing: DesignSystem.Spacing.medium) {
        StatCardView(
            title: "Inventory Value",
            value: "$1,234.56",
            accentColor: DesignSystem.textPrimary
        )
        StatCardView(
            title: "Low Stock",
            value: "5",
            accentColor: DesignSystem.warning,
            delta: StatCardView.Delta(value: "+2 this week", isPositive: false)
        )
        StatCardView(
            title: "Clients",
            value: "12",
            accentColor: DesignSystem.positive,
            delta: StatCardView.Delta(value: "+3 this month", isPositive: true)
        )
    }
    .padding()
    .background(DesignSystem.background)
}
