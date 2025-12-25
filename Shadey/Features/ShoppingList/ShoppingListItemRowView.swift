import SwiftUI

struct ShoppingListItemRowView: View {
    let item: ShoppingListItem
    let onRestock: () -> Void

    var body: some View {
        SurfaceCardView {
            HStack(alignment: .top, spacing: DesignSystem.Spacing.small) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                    Text(item.product?.displayName ?? "Product")
                        .font(DesignSystem.Typography.headline)
                        .foregroundStyle(DesignSystem.textPrimary)
                    Text("Need \(item.quantityNeeded.formatted(.number)) \(item.product?.resolvedUnit.displayName ?? "")")
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
                Spacer()
                Button("Restock", systemImage: "checkmark") {
                    onRestock()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
