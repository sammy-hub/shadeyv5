import SwiftUI

struct ShoppingListView: View {
    @State private var viewModel: ShoppingListViewModel
    @State private var showingManualAdd = false
    @State private var editingItem: ShoppingListItem?
    @State private var showingPurchased = false

    init(viewModel: ShoppingListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sectionSpacing) {
                ShoppingListSummaryCardView(
                    activeCount: viewModel.activeItems.count,
                    purchasedCount: viewModel.purchasedItems.count,
                    autoRestockOnPurchase: viewModel.autoRestockOnPurchase
                )

                if viewModel.activeItems.isEmpty {
                    ContentUnavailableView {
                        Label("All Stocked Up", systemImage: "checkmark.seal")
                    } description: {
                        Text("Items with low or empty stock appear here for quick restock.")
                    }
                    .padding(.vertical, DesignSystem.Spacing.xxLarge)
                } else {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
                        ForEach(viewModel.groupedActiveItems) { group in
                            ShoppingListBrandGroupView(
                                group: group,
                                autoRestockOnPurchase: viewModel.autoRestockOnPurchase,
                                onPurchased: viewModel.markPurchased(item:),
                                onRestock: viewModel.restock(item:),
                                onEdit: { editingItem = $0 },
                                onTogglePin: { item in
                                    viewModel.update(
                                        item: item,
                                        quantity: item.quantityNeeded,
                                        note: item.note,
                                        isPinned: !item.isPinned
                                    )
                                },
                                onUndo: viewModel.undoPurchased(item:)
                            )
                        }
                    }
                    .animation(.easeInOut, value: viewModel.activeItems.map(\.id))
                }

                if !viewModel.purchasedItems.isEmpty {
                    DisclosureGroup("Purchased", isExpanded: $showingPurchased) {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
                            ForEach(viewModel.groupedPurchasedItems) { group in
                                ShoppingListBrandGroupView(
                                    group: group,
                                    autoRestockOnPurchase: viewModel.autoRestockOnPurchase,
                                    onPurchased: viewModel.markPurchased(item:),
                                    onRestock: viewModel.restock(item:),
                                    onEdit: { editingItem = $0 },
                                    onTogglePin: { item in
                                        viewModel.update(
                                            item: item,
                                            quantity: item.quantityNeeded,
                                            note: item.note,
                                            isPinned: !item.isPinned
                                        )
                                    },
                                    onUndo: viewModel.undoPurchased(item:)
                                )
                            }
                        }
                        .padding(.top, DesignSystem.Spacing.small)
                    }
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.pagePadding)
            .padding(.vertical, DesignSystem.Spacing.large)
        }
        .background(DesignSystem.background)
        .scrollIndicators(.hidden)
        .navigationTitle("Shopping List")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add", systemImage: "plus") {
                    showingManualAdd = true
                }
            }
        }
        .sheet(isPresented: $showingManualAdd) {
            ShoppingListManualAddView(viewModel: viewModel)
        }
        .sheet(item: $editingItem) { item in
            ShoppingListItemEditorView(item: item) { quantity, note, isPinned in
                viewModel.update(item: item, quantity: quantity, note: note, isPinned: isPinned)
            }
        }
        .refreshable {
            viewModel.refresh()
        }
    }
}
