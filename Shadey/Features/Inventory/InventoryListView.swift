import SwiftUI

struct InventoryListView: View {
    @Bindable var viewModel: InventoryViewModel
    let onEdit: (Product) -> Void
    let onDeduct: (Product) -> Void
    let onDelete: (Product) -> Void
    let onAdd: () -> Void

    var body: some View {
        let isSearching = !viewModel.debouncedSearchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty

        let content: some View = Group {
            if isSearching {
                if viewModel.products.isEmpty {
                    InventoryEmptyStateView(
                        searchText: viewModel.searchText,
                        hasFilters: viewModel.hasActiveFilters,
                        onAdd: onAdd
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(
                        top: DesignSystem.Spacing.small,
                        leading: DesignSystem.Spacing.pagePadding,
                        bottom: DesignSystem.Spacing.small,
                        trailing: DesignSystem.Spacing.pagePadding
                    ))
                } else {
                    ForEach(viewModel.products, id: \.id) { product in
                        InventoryProductRowView(
                            product: product,
                            typeName: viewModel.store.productTypeStore.displayName(for: product.resolvedProductTypeId),
                            stockStatus: viewModel.stockStatus(for: product)
                        )
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(
                            top: DesignSystem.Spacing.xSmall,
                            leading: DesignSystem.Spacing.pagePadding,
                            bottom: DesignSystem.Spacing.xSmall,
                            trailing: DesignSystem.Spacing.pagePadding
                        ))
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button("Deduct", systemImage: "minus.circle") {
                                onDeduct(product)
                            }
                            .tint(DesignSystem.warning)
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button("Edit", systemImage: "pencil") {
                                onEdit(product)
                            }
                            Button("Delete", systemImage: "trash", role: .destructive) {
                                onDelete(product)
                            }
                        }
                    }
                }
            } else {
                if viewModel.products.isEmpty {
                    InventoryEmptyStateView(
                        searchText: viewModel.searchText,
                        hasFilters: viewModel.hasActiveFilters,
                        onAdd: onAdd
                    )
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(
                        top: DesignSystem.Spacing.small,
                        leading: DesignSystem.Spacing.pagePadding,
                        bottom: DesignSystem.Spacing.small,
                        trailing: DesignSystem.Spacing.pagePadding
                    ))
                } else {
                    ForEach(viewModel.categorySummaries) { summary in
                        NavigationLink(value: summary.category) {
                            InventoryCategoryRowView(summary: summary)
                        }
                        .buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets(
                            top: DesignSystem.Spacing.small,
                            leading: DesignSystem.Spacing.pagePadding,
                            bottom: DesignSystem.Spacing.small,
                            trailing: DesignSystem.Spacing.pagePadding
                        ))
                    }
                }
            }
        }

        return content
    }
}
