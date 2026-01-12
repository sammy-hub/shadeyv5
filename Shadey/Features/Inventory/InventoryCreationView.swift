import SwiftUI

struct InventoryCreationView: View {
    let store: InventoryStore
    let initialCategory: InventoryCategory?

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: InventoryCreationViewModel
    @State private var showsDeveloperEditor = false
    @State private var addMode: InventoryAddMode = .fast

    init(store: InventoryStore, initialCategory: InventoryCategory? = nil) {
        self.store = store
        self.initialCategory = initialCategory
        _viewModel = State(
            initialValue: InventoryCreationViewModel(
                store: store,
                initialCategory: initialCategory ?? .hairColor
            )
        )
    }

    var body: some View {
        @Bindable var viewModel = viewModel
        let categoryBinding = Binding<InventoryCategory>(
            get: { viewModel.selectedCategory },
            set: { viewModel.updateCategory($0) }
        )

        return NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sectionSpacing) {
                    Picker("Category", selection: categoryBinding) {
                        ForEach(InventoryCategory.allCases) { category in
                            Text(category.displayName)
                                .tag(category)
                        }
                    }
                    .pickerStyle(.segmented)

                    if viewModel.selectedCategory == .hairColor {
                        ColorLineDefaultsSectionView(viewModel: viewModel) {
                            showsDeveloperEditor = true
                        }

                        Picker("Add Mode", selection: $addMode) {
                            ForEach(InventoryAddMode.allCases) { mode in
                                Text(mode.displayName)
                                    .tag(mode)
                            }
                        }
                        .pickerStyle(.segmented)

                        if addMode == .fast {
                            QuickAddShadeSectionView(viewModel: viewModel)
                        } else {
                            BulkAddShadesSectionView(viewModel: viewModel)
                        }

                        QueuedShadesSectionView(viewModel: viewModel)
                    } else {
                        InventorySingleProductSectionView(viewModel: viewModel, category: viewModel.selectedCategory)
                    }
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
