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
                InventoryEmptyStateView(
                    searchText: viewModel.searchText,
                    hasFilters: viewModel.hasActiveFilters,
                    onAdd: onAdd
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            } else {
                ForEach(sections) { section in
                    let isExpanded = Binding<Bool>(
                        get: { expandedLineIds.contains(section.id) },
                        set: { newValue in
                            if newValue {
                                expandedLineIds.insert(section.id)
                            } else {
                                expandedLineIds.remove(section.id)
                            }
                        }
                    )

                    InventoryLineDisclosureGroupView(
                        viewModel: viewModel,
                        section: section,
                        itemLabel: itemLabel,
                        isExpanded: isExpanded,
                        onEdit: onEdit,
                        onDeduct: onDeduct,
                        onDelete: onDelete
                    )
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .background(DesignSystem.background)
        .navigationTitle(category.displayName)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add", systemImage: "plus") {
                    onAdd()
                }
                .accessibilityIdentifier("inventoryCategoryAddButton")
            }
        }
        .onChange(of: sections.map(\.id)) { _, newValue in
            expandedLineIds = expandedLineIds.filter { newValue.contains($0) }
        }
    }
}
