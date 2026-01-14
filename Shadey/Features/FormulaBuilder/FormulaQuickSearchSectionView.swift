import SwiftUI

struct FormulaQuickSearchSectionView: View {
    @Bindable var viewModel: ServiceEditorViewModel
    let formulaId: UUID

    var body: some View {
        let searchBinding = Binding<String>(
            get: { viewModel.searchText(for: formulaId) },
            set: { viewModel.updateSearchText($0, for: formulaId) }
        )

        SwiftUI.Section {
            TextField("Search shades or brands", text: searchBinding)
                .accessibilityIdentifier("formulaSearchField")

            if viewModel.searchText(for: formulaId).trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                if !viewModel.favoriteProducts.isEmpty {
                    FormulaChipRowView(
                        title: "Favorites",
                        products: viewModel.favoriteProducts,
                        onSelect: { viewModel.addSelection(for: $0, formulaId: formulaId) }
                    )
                }

                if !viewModel.recentProducts.isEmpty {
                    FormulaChipRowView(
                        title: "Recents",
                        products: viewModel.recentProducts,
                        onSelect: { viewModel.addSelection(for: $0, formulaId: formulaId) }
                    )
                }

                if viewModel.favoriteProducts.isEmpty && viewModel.recentProducts.isEmpty {
                    Text("Search to add products to this formula.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
            } else {
                let results = viewModel.filteredColorProducts(for: formulaId)
                if results.isEmpty {
                    Text("No matches yet.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                } else {
                    ForEach(results, id: \.id) { product in
                        FormulaProductResultRowView(
                            product: product,
                            typeName: viewModel.typeName(for: product),
                            showsStock: viewModel.showsStockInSelection,
                            isFavorite: viewModel.isFavorite(product)
                        ) {
                            viewModel.addSelection(for: product, formulaId: formulaId)
                        } onToggleFavorite: {
                            viewModel.toggleFavorite(for: product)
                        }
                    }
                }
            }
        } header: {
            Text("Add Products")
        } footer: {
            Text("Search your inventory by shade, brand, or line.")
        }
    }
}

struct FormulaChipRowView: View {
    let title: String
    let products: [Product]
    let onSelect: (Product) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
            Text(title)
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(DesignSystem.textSecondary)

            ScrollView(.horizontal) {
                HStack(spacing: DesignSystem.Spacing.small) {
                    ForEach(products, id: \.id) { product in
                        Button(product.shadeLabel) {
                            onSelect(product)
                        }
                        .buttonStyle(.bordered)
                        .accessibilityLabel("Add \(product.shadeLabel)")
                    }
                }
                .padding(.vertical, DesignSystem.Spacing.xSmall)
            }
            .scrollIndicators(.hidden)
        }
    }
}
