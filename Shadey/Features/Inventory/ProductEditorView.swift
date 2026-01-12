import SwiftUI

struct ProductEditorView: View {
    let store: InventoryStore
    let product: Product?

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ProductEditorViewModel
    @State private var showsAdvancedFields = false

    init(
        store: InventoryStore,
        product: Product? = nil,
        prefilledBarcode: String? = nil,
        prefilledBrand: String? = nil,
        prefilledProductTypeId: String? = nil
    ) {
        self.store = store
        self.product = product
        _viewModel = State(
            initialValue: ProductEditorViewModel(
                store: store,
                product: product,
                prefilledBarcode: prefilledBarcode,
                prefilledBrand: prefilledBrand,
                prefilledProductTypeId: prefilledProductTypeId
            )
        )
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        return NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sectionSpacing) {
                    ProductEditorDetailsSectionView(viewModel: viewModel)
                    ProductEditorStockSectionView(viewModel: viewModel)
                    Button(
                        showsAdvancedFields ? "Hide Advanced Fields" : "Show Pricing, Developer, Barcode",
                        systemImage: showsAdvancedFields ? "chevron.up" : "chevron.down"
                    ) {
                        showsAdvancedFields.toggle()
                    }
                    .buttonStyle(.bordered)

                    if showsAdvancedFields {
                        ProductEditorPricingSectionView(viewModel: viewModel)
                        if viewModel.isDeveloperType {
                            ProductEditorDeveloperStrengthSectionView(viewModel: viewModel)
                        } else if viewModel.supportsDeveloperGuidance {
                            ProductEditorDeveloperGuidanceSectionView(viewModel: viewModel)
                        }
                        ProductEditorBarcodeSectionView(viewModel: viewModel)
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.pagePadding)
                .padding(.vertical, DesignSystem.Spacing.large)
            }
            .background(DesignSystem.background)
            .scrollIndicators(.hidden)
            .navigationTitle(viewModel.isEditing ? "Edit Product" : "Add Product")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.save()
                        dismiss()
                    }
                    .disabled(!viewModel.isSaveEnabled)
                }
            }
        }
    }
}
