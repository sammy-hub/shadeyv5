import SwiftUI

struct InventoryView: View {
    @State private var viewModel: InventoryViewModel
    @State private var showingAddProduct = false
    @State private var showingScanner = false
    @State private var editingProduct: Product?
    @State private var adjustingProduct: Product?
    @State private var deletingProduct: Product?

    init(viewModel: InventoryViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        return InventoryRootView(
            viewModel: viewModel,
            showingAddProduct: $showingAddProduct,
            showingScanner: $showingScanner,
            editingProduct: $editingProduct,
            adjustingProduct: $adjustingProduct,
            deletingProduct: $deletingProduct
        )
    }
}
