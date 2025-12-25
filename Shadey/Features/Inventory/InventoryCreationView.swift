import SwiftUI

struct InventoryCreationView: View {
    let store: InventoryStore

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: InventoryCreationViewModel
    @State private var showsDeveloperEditor = false

    init(store: InventoryStore) {
        self.store = store
        _viewModel = State(initialValue: InventoryCreationViewModel(store: store))
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        return NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sectionSpacing) {
                    ColorLineDefaultsSectionView(viewModel: viewModel) {
                        showsDeveloperEditor = true
                    }
                    QuickAddShadeSectionView(viewModel: viewModel)
                    BulkAddShadesSectionView(viewModel: viewModel)
                }
                .padding(.horizontal, DesignSystem.Spacing.pagePadding)
                .padding(.vertical, DesignSystem.Spacing.large)
            }
            .background(DesignSystem.background)
            .scrollIndicators(.hidden)
            .navigationTitle("Add Inventory")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.saveAll()
                        dismiss()
                    }
                    .disabled(!viewModel.canSave)
                }
            }
        }
        .sheet(isPresented: $showsDeveloperEditor) {
            ProductEditorView(
                store: store,
                prefilledBrand: viewModel.lineDraft.brand,
                prefilledProductTypeId: ProductType.developer.rawValue
            )
        }
    }
}
