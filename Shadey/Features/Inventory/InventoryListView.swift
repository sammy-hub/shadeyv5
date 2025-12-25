import SwiftUI

struct InventoryListView: View {
    @Bindable var viewModel: InventoryViewModel
    let onEdit: (Product) -> Void
    let onDeduct: (Product) -> Void
    let onDelete: (Product) -> Void
    let onAdd: () -> Void
    @State private var expandedLineIds: Set<String> = []

    var body: some View {
        let lineIds = viewModel.lineSections.map(\.id)

        let content: some View = Group {
            if viewModel.lineSections.isEmpty {
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
                ForEach(viewModel.lineSections) { section in
                    InventoryColorLineRowView(
                        section: section,
                        isExpanded: expandedLineIds.contains(section.id)
                    ) {
                        toggleLine(section.id)
                    }
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(
                        top: DesignSystem.Spacing.small,
                        leading: DesignSystem.Spacing.pagePadding,
                        bottom: DesignSystem.Spacing.small,
                        trailing: DesignSystem.Spacing.pagePadding
                    ))

                    if expandedLineIds.contains(section.id) {
                        ForEach(section.shades, id: \.id) { product in
                            NavigationLink(value: product.id) {
                                ProductRowView(
                                    product: product,
                                    typeName: viewModel.store.productTypeStore.displayName(for: product.resolvedProductTypeId)
                                )
                                    .padding(.vertical, DesignSystem.Spacing.xSmall)
                            }
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
                }
            }
        }

        return content
            .onChange(of: lineIds) { _, newValue in
                expandedLineIds = expandedLineIds.filter { newValue.contains($0) }
            }
    }

    private func toggleLine(_ id: String) {
        if expandedLineIds.contains(id) {
            expandedLineIds.remove(id)
        } else {
            expandedLineIds.insert(id)
        }
    }
}
