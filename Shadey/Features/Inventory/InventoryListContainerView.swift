import SwiftUI

struct InventoryListContainerView: View {
    @Bindable var viewModel: InventoryViewModel
    @Binding var showingAddProduct: Bool
    @Binding var editingProduct: Product?
    @Binding var adjustingProduct: Product?
    @Binding var deletingProduct: Product?

    var body: some View {
        List {
            InventorySummarySectionView(viewModel: viewModel)
            InventoryFilterBarView(viewModel: viewModel)

            InventoryListView(
                viewModel: viewModel,
                onEdit: { editingProduct = $0 },
                onDeduct: { adjustingProduct = $0 },
                onDelete: { deletingProduct = $0 },
                onAdd: { showingAddProduct = true }
            )
        }
        .listStyle(.insetGrouped)
    }
}
