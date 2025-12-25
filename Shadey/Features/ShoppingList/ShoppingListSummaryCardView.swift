import SwiftUI

struct ShoppingListSummaryCardView: View {
    let totalItems: Int

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Restock Queue")
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Text("\(totalItems) items to reorder")
                    .font(DesignSystem.Typography.title)
                    .bold()
                    .foregroundStyle(DesignSystem.textPrimary)
                Text("Check an item to re-add it to inventory.")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
        }
    }
}
