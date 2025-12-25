import SwiftUI

struct ProductRowView: View {
    let product: Product
    let typeName: String

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                HStack(alignment: .top, spacing: DesignSystem.Spacing.small) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                        Text(headerSubtitle(for: product))
                            .font(DesignSystem.Typography.caption)
                            .foregroundStyle(DesignSystem.textSecondary)
                        Text(product.shadeLabel)
                            .font(DesignSystem.Typography.headline)
                            .foregroundStyle(DesignSystem.textPrimary)
                        Text(typeName)
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                    Spacer()
                    StockStatusBadgeView(status: product.stockStatus)
                }
                HStack {
                    Text("\(product.stockQuantity.formatted(.number)) \(product.resolvedUnit.displayName)")
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundStyle(DesignSystem.textPrimary)
                    Spacer()
                    Text(product.costPerUnit, format: CurrencyFormat.inventory)
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
            }
        }
    }

    private func headerSubtitle(for product: Product) -> String {
        if let lineName = product.colorLine?.name, !lineName.isEmpty {
            return "\(product.resolvedBrand) - \(lineName)"
        }
        return product.resolvedBrand
    }
}
