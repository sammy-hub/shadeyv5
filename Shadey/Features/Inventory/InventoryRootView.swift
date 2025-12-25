import SwiftUI

struct InventoryRootView: View {
    @Bindable var viewModel: InventoryViewModel
    @Binding var showingAddProduct: Bool
    @Binding var showingScanner: Bool
    @Binding var editingProduct: Product?
    @Binding var adjustingProduct: Product?
    @Binding var deletingProduct: Product?

    var body: some View {
        let deleteDialogBinding = Binding<Bool>(
            get: { deletingProduct != nil },
            set: { isPresented in
                if !isPresented {
                    deletingProduct = nil
                }
            }
        )

        let listView = InventoryListContainerView(
            viewModel: viewModel,
            showingAddProduct: $showingAddProduct,
            editingProduct: $editingProduct,
            adjustingProduct: $adjustingProduct,
            deletingProduct: $deletingProduct
        )
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .background(DesignSystem.background)

        let navigationView = listView
            .navigationTitle("Inventory")
            .toolbar {
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Scan", systemImage: "barcode.viewfinder") {
                        showingScanner = true
                    }
                    Button("Add", systemImage: "plus") {
                        showingAddProduct = true
                    }
                }
            }
            .searchable(text: $viewModel.searchText, prompt: "Search products")
            .navigationDestination(for: UUID.self) { id in
                if let product = viewModel.product(for: id) {
                    ProductDetailView(product: product, store: viewModel.store)
                }
            }

        let sheetView = navigationView
            .sheet(isPresented: $showingAddProduct) {
                InventoryCreationView(store: viewModel.store)
            }
            .sheet(item: $editingProduct) { product in
                ProductEditorView(store: viewModel.store, product: product)
            }
            .sheet(item: $adjustingProduct) { product in
                StockAdjustmentView(store: viewModel.store, product: product, initialAdjustmentType: .deduct)
            }
            .sheet(isPresented: $showingScanner) {
                InventoryScannerView(store: viewModel.store)
            }

        return sheetView
            .confirmationDialog("Delete Product", isPresented: deleteDialogBinding, presenting: deletingProduct) { product in
                Button("Delete", role: .destructive) {
                    viewModel.store.delete(product: product)
                    deletingProduct = nil
                }
                Button("Cancel", role: .cancel) {
                    deletingProduct = nil
                }
            } message: { product in
                Text("Delete \(product.displayName)? This can’t be undone.")
            }
    }
}
