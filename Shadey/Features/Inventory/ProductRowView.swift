import SwiftUI

struct ProductRowView: View {
    let product: Product
    let typeName: String
    let stockStatus: StockStatus

    var body: some View {
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
                StockStatusBadgeView(status: stockStatus)
            }
            HStack(alignment: .top) {
                Text("In stock: \(product.stockQuantity.formatted(.number))")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Spacer()
                VStack(alignment: .trailing, spacing: DesignSystem.Spacing.xSmall) {
                    Text(product.purchasePrice, format: CurrencyFormat.inventory)
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundStyle(DesignSystem.textPrimary)
                    Text("Last paid price")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                    HStack(spacing: DesignSystem.Spacing.xSmall) {
                        Text(costPerUnitText)
                            .font(DesignSystem.Typography.caption)
                            .foregroundStyle(DesignSystem.textPrimary)
                        Text("per \(product.resolvedUnit.displayName)")
                            .font(DesignSystem.Typography.caption)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                }
            }
        }
    }

    private var costPerUnitText: String {
        guard product.costPerUnit > 0 else { return "--" }
        return product.costPerUnit.formatted(CurrencyFormat.inventory)
    }

    private func headerSubtitle(for product: Product) -> String {
        if let lineName = product.colorLine?.name, !lineName.isEmpty {
            return "\(product.resolvedBrand) - \(lineName)"
        }
        return product.resolvedBrand
    }
}
