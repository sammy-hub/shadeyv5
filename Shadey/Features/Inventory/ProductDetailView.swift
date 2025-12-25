import SwiftUI

struct ProductDetailView: View {
    let product: Product
    let store: InventoryStore

    @State private var showingEditor = false
    @State private var showingAdjustment = false

    var body: some View {
        let typeName = store.productTypeStore.displayName(for: product.resolvedProductTypeId)
        let isDeveloper = store.productTypeStore.isDeveloperType(product.resolvedProductTypeId)

        ScrollView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sectionSpacing) {
                SurfaceCardView {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        HStack(alignment: .top, spacing: DesignSystem.Spacing.small) {
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                                Text(detailHeaderSubtitle(for: product))
                                    .font(DesignSystem.Typography.caption)
                                    .foregroundStyle(DesignSystem.textSecondary)
                                Text(product.shadeLabel)
                                    .font(DesignSystem.Typography.title)
                                    .bold()
                                    .foregroundStyle(DesignSystem.textPrimary)
                                Text(typeName)
                                    .font(DesignSystem.Typography.subheadline)
                                    .foregroundStyle(DesignSystem.textSecondary)
                            }
                            Spacer()
                            StockStatusBadgeView(status: product.stockStatus)
                        }
                        KeyValueRowView(title: "Stock", value: "\(product.stockQuantity.formatted(.number)) \(product.resolvedUnit.displayName)")
                        KeyValueRowView(title: "Cost per unit", value: product.costPerUnit.formatted(CurrencyFormat.inventory))
                        KeyValueRowView(title: "Purchase price", value: product.resolvedPurchasePrice.formatted(CurrencyFormat.inventory))
                        KeyValueRowView(title: "Quantity per unit", value: "\(product.resolvedQuantityPerUnit.formatted(.number)) \(product.resolvedUnit.displayName)")
                        KeyValueRowView(title: "Low stock", value: product.lowStockThreshold.formatted(.number))
                        KeyValueRowView(title: "Overstock", value: product.overstockThreshold.formatted(.number))
                        if let barcode = product.barcode {
                            KeyValueRowView(title: "Barcode", value: barcode)
                        }
                        if isDeveloper, product.developerStrength > 0 {
                            KeyValueRowView(title: "Strength", value: "\(product.developerStrength) vol")
                        }
                        if !isDeveloper, product.resolvedDefaultDeveloperRatio > 0 {
                            KeyValueRowView(title: "Developer : Color", value: "\(product.resolvedDefaultDeveloperRatio.formatted(.number)) : 1")
                        }
                        if let notes = product.notes, !notes.isEmpty {
                            Text(notes)
                                .font(DesignSystem.Typography.subheadline)
                                .foregroundStyle(DesignSystem.textSecondary)
                        }
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.pagePadding)
            .padding(.vertical, DesignSystem.Spacing.large)
        }
        .background(DesignSystem.background)
        .navigationTitle("Product")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Adjust", systemImage: "scale.3d") {
                    showingAdjustment = true
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit", systemImage: "square.and.pencil") {
                    showingEditor = true
                }
            }
        }
        .sheet(isPresented: $showingEditor) {
            ProductEditorView(store: store, product: product)
        }
        .sheet(isPresented: $showingAdjustment) {
            StockAdjustmentView(store: store, product: product)
        }
    }

    private func detailHeaderSubtitle(for product: Product) -> String {
        if let lineName = product.colorLine?.name, !lineName.isEmpty {
            return "\(product.resolvedBrand) - \(lineName)"
        }
        return product.resolvedBrand
    }
}
