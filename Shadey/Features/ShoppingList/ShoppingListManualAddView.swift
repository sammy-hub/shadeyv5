import SwiftUI

struct ShoppingListManualAddView: View {
    @Bindable var viewModel: ShoppingListViewModel

    @Environment(\.dismiss) private var dismiss
    @State private var searchText: String = ""
    @State private var selectedProduct: Product?
    @State private var quantity: Double?
    @State private var note: String = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sectionSpacing) {
                    SurfaceCardView {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                            SectionHeaderView(title: "Add Item", subtitle: "Search inventory to add a manual restock.")
                            FieldContainerView {
                                TextField("Search shades or brands", text: $searchText)
                            }
                        }
                    }

                    if let product = selectedProduct {
                        SurfaceCardView {
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                Text(product.displayName)
                                    .font(DesignSystem.Typography.headline)
                                    .foregroundStyle(DesignSystem.textPrimary)
                                Text("Unit \(product.resolvedUnit.displayName)")
                                    .font(DesignSystem.Typography.caption)
                                    .foregroundStyle(DesignSystem.textSecondary)
                                FieldContainerView {
                                    OptionalNumberField("Quantity", value: $quantity, format: .number)
                                }
                                FieldContainerView {
                                    TextField("Note (optional)", text: $note)
                                }
                                Button("Add to List", systemImage: "plus") {
                                    guard let quantity else { return }
                                    viewModel.addManualItem(product: product, quantity: quantity, note: note)
                                    dismiss()
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled((quantity ?? 0) <= 0)
                            }
                        }
                    }

                    if !searchText.isEmpty {
                        let results = viewModel.searchProducts(matching: searchText)
                        if results.isEmpty {
                            Text("No matching products.")
                                .font(DesignSystem.Typography.subheadline)
                                .foregroundStyle(DesignSystem.textSecondary)
                        } else {
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                ForEach(results, id: \.id) { product in
                                    Button {
                                        select(product)
                                    } label: {
                                        HStack {
                                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                                                Text(product.displayName)
                                                    .font(DesignSystem.Typography.subheadline)
                                                    .foregroundStyle(DesignSystem.textPrimary)
                                                Text(product.resolvedBrand)
                                                    .font(DesignSystem.Typography.caption)
                                                    .foregroundStyle(DesignSystem.textSecondary)
                                            }
                                            Spacer()
                                            Image(systemName: "plus.circle")
                                                .foregroundStyle(DesignSystem.accent)
                                        }
                                        .padding(.vertical, DesignSystem.Spacing.xSmall)
                                    }
                                    .buttonStyle(.plain)
                                    if product.id != results.last?.id {
                                        Divider()
                                    }
                                }
                            }
                            .padding(.horizontal, DesignSystem.Spacing.pagePadding)
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.pagePadding)
                .padding(.vertical, DesignSystem.Spacing.large)
            }
            .background(DesignSystem.background)
            .scrollIndicators(.hidden)
            .navigationTitle("Manual Add")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func select(_ product: Product) {
        selectedProduct = product
        if quantity == nil || quantity == 0 {
            quantity = defaultQuantity(for: product)
        }
        note = ""
    }

    private func defaultQuantity(for product: Product) -> Double {
        let threshold = viewModel.effectiveLowStockThreshold(for: product)
        if threshold > 0 {
            return max(threshold, product.resolvedQuantityPerUnit)
        }
        if product.resolvedQuantityPerUnit > 0 {
            return product.resolvedQuantityPerUnit
        }
        return 1
    }
}
