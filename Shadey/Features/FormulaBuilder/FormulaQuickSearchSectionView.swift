import SwiftUI

struct FormulaQuickSearchSectionView: View {
    @Bindable var viewModel: ServiceEditorViewModel
    let formula: ServiceFormulaDraft

    var body: some View {
        let searchBinding = Binding<String>(
            get: { viewModel.searchText(for: formula.id) },
            set: { viewModel.updateSearchText($0, for: formula.id) }
        )

        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            SectionHeaderView(title: "Add Products", subtitle: "Search shades, favorites, and recents.")

            TextField("Search shades or brands", text: searchBinding)
                .textFieldStyle(.roundedBorder)

            if viewModel.searchText(for: formula.id).trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                if !viewModel.favoriteProducts.isEmpty {
                    FormulaChipRowView(
                        title: "Favorites",
                        products: viewModel.favoriteProducts,
                        onSelect: { viewModel.addSelection(for: $0, formulaId: formula.id) }
                    )
                }

                if !viewModel.recentProducts.isEmpty {
                    FormulaChipRowView(
                        title: "Recents",
                        products: viewModel.recentProducts,
                        onSelect: { viewModel.addSelection(for: $0, formulaId: formula.id) }
                    )
                }
            } else {
                let results = viewModel.filteredColorProducts(for: formula.id)
                if results.isEmpty {
                    Text("No matches yet.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                } else {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                        ForEach(results, id: \.id) { product in
                            FormulaProductResultRowView(
                                product: product,
                                typeName: viewModel.typeName(for: product),
                                showsStock: viewModel.showsStockInSelection,
                                isFavorite: viewModel.isFavorite(product)
                            ) {
                                viewModel.addSelection(for: product, formulaId: formula.id)
                            } onToggleFavorite: {
                                viewModel.toggleFavorite(for: product)
                            }
                            if product.id != results.last?.id {
                                Divider()
                            }
                        }
                    }
                }
            }
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
                    }
                }
                .padding(.vertical, DesignSystem.Spacing.xSmall)
            }
            .scrollIndicators(.hidden)
        }
    }
}
