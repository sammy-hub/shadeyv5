import SwiftUI

struct InventoryCategoryDetailView: View {
    @Bindable var viewModel: InventoryViewModel
    let category: InventoryCategory
    let onEdit: (Product) -> Void
    let onDeduct: (Product) -> Void
    let onDelete: (Product) -> Void
    let onAdd: () -> Void
    @State private var expandedLineIds: Set<String> = []

    var body: some View {
        let sections = viewModel.lineSections(for: category)
        let itemLabel = category == .hairColor ? "shades" : "items"

        return List {
            if sections.isEmpty {
                emptyState()
            } else {
                ForEach(sections) { section in
                    sectionHeader(section: section, itemLabel: itemLabel)
                    if expandedLineIds.contains(section.id) {
                        expandedProductsList(for: section)
                    }
                }
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .background(DesignSystem.background)
        .navigationTitle(category.displayName)
        .toolbar { addToolbar() }
        .onChange(of: sections.map(\.id)) { _, newValue in
            expandedLineIds = expandedLineIds.filter { newValue.contains($0) }
        }
    }

    @ViewBuilder
    private func emptyState() -> some View {
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
    }

    @ViewBuilder
    private func sectionHeader(section: InventoryLineSection, itemLabel: String) -> some View {
        Group {
            if category == .hairColor {
                InventoryColorLineRowView(
                    section: section,
                    isExpanded: expandedLineIds.contains(section.id)
                ) {
                    toggleLine(section.id)
                }
            } else {
                InventoryLineRowView(
                    section: section,
                    isExpanded: expandedLineIds.contains(section.id),
                    itemLabel: itemLabel
                ) {
                    toggleLine(section.id)
                }
            }
        }
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
        .listRowInsets(EdgeInsets(
            top: DesignSystem.Spacing.small,
            leading: DesignSystem.Spacing.pagePadding,
            bottom: DesignSystem.Spacing.small,
            trailing: DesignSystem.Spacing.pagePadding
        ))
    }

    @ViewBuilder
    private func expandedProductsList(for section: InventoryLineSection) -> some View {
        ForEach(section.shades, id: \.id) { product in
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

    @ToolbarContentBuilder
    private func addToolbar() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button("Add", systemImage: "plus") {
                onAdd()
            }
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
