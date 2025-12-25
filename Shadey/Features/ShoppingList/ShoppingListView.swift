import SwiftUI

struct ShoppingListView: View {
    @State private var viewModel: ShoppingListViewModel

    init(viewModel: ShoppingListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.sectionSpacing) {
                ShoppingListSummaryCardView(totalItems: viewModel.items.count)
                if viewModel.items.isEmpty {
                    ContentUnavailableView {
                        Label("All Stocked Up", systemImage: "checkmark.seal")
                    } description: {
                        Text("Items with low or empty stock appear here for quick restock.")
                    }
                    .padding(.vertical, DesignSystem.Spacing.xxLarge)
                } else {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        ForEach(viewModel.items, id: \.id) { item in
                            ShoppingListItemRowView(item: item) {
                                viewModel.restock(item: item)
                            }
                        }
                    }
                    .animation(.easeInOut, value: viewModel.items.map(\.id))
                }
            }
            .padding(.horizontal, DesignSystem.Spacing.pagePadding)
            .padding(.vertical, DesignSystem.Spacing.large)
        }
        .background(DesignSystem.background)
        .scrollIndicators(.hidden)
        .navigationTitle("Shopping List")
        .refreshable {
            viewModel.refresh()
        }
    }
}
