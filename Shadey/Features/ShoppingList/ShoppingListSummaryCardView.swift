import SwiftUI

struct ShoppingListSummaryCardView: View {
    let activeCount: Int
    let purchasedCount: Int
    let autoRestockOnPurchase: Bool

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Restock Queue")
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Text("\(activeCount) active / \(purchasedCount) purchased")
                    .font(DesignSystem.Typography.title)
                    .bold()
                    .foregroundStyle(DesignSystem.textPrimary)
                Text(autoRestockOnPurchase ? "Auto-restock is on." : "Mark purchased to clear items.")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
        }
    }
}
