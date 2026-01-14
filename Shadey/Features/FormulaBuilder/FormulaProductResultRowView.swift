import SwiftUI

struct FormulaProductResultRowView: View {
    let product: Product
    let typeName: String
    let showsStock: Bool
    let isFavorite: Bool
    let onAdd: () -> Void
    let onToggleFavorite: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: DesignSystem.Spacing.small) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                Text(product.displayName)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Text(typeName)
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.textSecondary)
                if showsStock {
                    Text("Stock \(product.stockQuantity.formatted(.number)) \(product.resolvedUnit.displayName)")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
            }
            Spacer()
            HStack(spacing: DesignSystem.Spacing.small) {
                Button("Add", systemImage: "plus") {
                    onAdd()
                }
                .buttonStyle(.bordered)
                .accessibilityLabel("Add \(product.displayName)")

                Button(isFavorite ? "Unfavorite" : "Favorite", systemImage: isFavorite ? "star.fill" : "star") {
                    onToggleFavorite()
                }
                .buttonStyle(.bordered)
                .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
            }
        }
        .padding(.vertical, DesignSystem.Spacing.xSmall)
    }
}
