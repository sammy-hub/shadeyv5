import SwiftUI

struct InventoryListView: View {
    @Bindable var viewModel: InventoryViewModel
    let onEdit: (Product) -> Void
    let onDeduct: (Product) -> Void
    let onDelete: (Product) -> Void
    let onAdd: () -> Void

    var body: some View {
        let trimmedSearch = viewModel.debouncedSearchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let isSearching = !trimmedSearch.isEmpty

        if viewModel.products.isEmpty {
            InventoryEmptyStateView(
                searchText: viewModel.searchText,
                hasFilters: viewModel.hasActiveFilters,
                onAdd: onAdd
            )
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
        } else {
            if !isSearching {
                Section("Categories") {
                    ForEach(viewModel.categorySummaries) { summary in
                        NavigationLink(value: summary.category) {
                            InventoryCategoryRowView(summary: summary)
                        }
                    }
                }
            }

            Section {
                ForEach(viewModel.products, id: \.id) { product in
                    let subtitle = viewModel.productSubtitle(for: product)
                    let stockText = viewModel.stockText(for: product)
                    let unitCostText = viewModel.unitCostText(for: product)

                    NavigationLink(value: product.id) {
                        InventoryTableRowView(
                            title: product.shadeLabel,
                            subtitle: subtitle,
                            stockText: stockText,
                            unitCostText: unitCostText,
                            stockStatus: viewModel.stockStatus(for: product)
                        )
                    }
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
            } header: {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                    Text("All Products")
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundStyle(DesignSystem.textSecondary)
                    InventoryTableHeaderView()
                }
            }
        }
    }
}
