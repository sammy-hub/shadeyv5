import SwiftUI

struct ProductDetailView: View {
    let product: Product
    let store: InventoryStore
    let stockAlertSettingsStore: StockAlertSettingsStore

    @State private var showingEditor = false
    @State private var showingAdjustment = false

    var body: some View {
        let typeName = store.productTypeStore.displayName(for: product.resolvedProductTypeId)
        let isDeveloper = store.productTypeStore.isDeveloperType(product.resolvedProductTypeId)
        let stockStatus = stockAlertSettingsStore.stockStatus(for: product)
        let thresholdDetails = stockAlertSettingsStore.thresholdDetails(for: product)

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
                            StockStatusBadgeView(status: stockStatus)
                        }
                        KeyValueRowView(
                            title: "Units in stock",
                            value: product.stockQuantity.formatted(.number)
                        )
                        KeyValueRowView(title: "Cost per unit", value: product.resolvedPurchasePrice.formatted(CurrencyFormat.inventory))
                        KeyValueRowView(title: "Amount per unit", value: "\(product.resolvedQuantityPerUnit.formatted(.number)) \(product.resolvedUnit.displayName)")
                        let lowStockValue = thresholdDetails.value > 0
                            ? "\(thresholdDetails.value.formatted(.number)) \(product.resolvedUnit.displayName) (\(thresholdDetails.source.displayName))"
                            : "Not set"
                        KeyValueRowView(title: "Low stock", value: lowStockValue)
                        KeyValueRowView(title: "Overstock", value: product.overstockThreshold.formatted(.number))
                        KeyValueRowView(title: "Auto-add to shopping", value: product.autoAddDisabled ? "Off" : "On")
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

