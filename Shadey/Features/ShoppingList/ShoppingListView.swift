import SwiftUI

struct ShoppingListView: View {
    @State private var viewModel: ShoppingListViewModel
    @State private var showingManualAdd = false
    @State private var editingItem: ShoppingListItem?
    @State private var showsPurchased = false

    init(viewModel: ShoppingListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        List {
            if viewModel.activeItems.isEmpty {
                ContentUnavailableView {
                    Label("All Stocked Up", systemImage: "checkmark.seal")
                } description: {
                    Text("Items with low or empty stock appear here for quick restock.")
                } actions: {
                    Button("Add Item", systemImage: "plus") {
                        showingManualAdd = true
                    }
                    .buttonStyle(.borderedProminent)
                    .accessibilityIdentifier("shoppingListEmptyAddButton")
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            } else {
                Section("Needs Restock") {
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
            }

            if !viewModel.purchasedItems.isEmpty, (showsPurchased || viewModel.activeItems.isEmpty) {
                Section("Purchased") {
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
            }
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Shopping List")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add", systemImage: "plus") {
                    showingManualAdd = true
                }
                .accessibilityIdentifier("shoppingListAddButton")
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    if !viewModel.purchasedItems.isEmpty {
                        Toggle("Show Purchased", isOn: $showsPurchased)
                    }
                } label: {
                    Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
                }
                .accessibilityIdentifier("shoppingListFiltersMenu")
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
