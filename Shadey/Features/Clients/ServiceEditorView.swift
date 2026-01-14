import PhotosUI
import SwiftUI

struct ServiceEditorView: View {
    let inventoryStore: InventoryStore
    let preferencesStore: FormulaBuilderPreferencesStore
    let onSave: (ServiceDraft) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ServiceEditorViewModel
    @State private var beforePhotoItem: PhotosPickerItem?
    @State private var afterPhotoItem: PhotosPickerItem?

    init(
        inventoryStore: InventoryStore,
        preferencesStore: FormulaBuilderPreferencesStore,
        onSave: @escaping (ServiceDraft) -> Void
    ) {
        self.inventoryStore = inventoryStore
        self.preferencesStore = preferencesStore
        self.onSave = onSave
        _viewModel = State(
            initialValue: ServiceEditorViewModel(
                inventoryStore: inventoryStore,
                preferencesStore: preferencesStore
            )
        )
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        return NavigationStack {
            Form {
                ServiceDetailsSectionView(viewModel: viewModel)
                ServiceFormulasSectionView(viewModel: viewModel)
                ServicePhotosSectionView(
                    beforePhotoData: viewModel.draft.beforePhotoData,
                    afterPhotoData: viewModel.draft.afterPhotoData,
                    beforePhotoItem: $beforePhotoItem,
                    afterPhotoItem: $afterPhotoItem
                )
                FormulaDeductionFootnoteView(
                    lines: viewModel.deductionLines,
                    totalDeduction: viewModel.totalDeduction
                )
                ServiceSummarySectionView(viewModel: viewModel)
            }
            .navigationTitle("New Service")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                    .accessibilityIdentifier("serviceCancelButton")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave(viewModel.finalizedDraft())
                        dismiss()
                    }
                    .disabled(viewModel.draft.formulas.allSatisfy { $0.selections.isEmpty })
                    .accessibilityIdentifier("serviceSaveButton")
                }
            }
            .navigationDestination(for: UUID.self) { formulaId in
                FormulaEditorView(viewModel: viewModel, formulaId: formulaId)
            }
            .onChange(of: beforePhotoItem) { _, newValue in
                Task {
                    let data = try? await newValue?.loadTransferable(type: Data.self)
                    await MainActor.run {
                        viewModel.updateBeforePhotoData(data)
                    }
                }
            }
            .onChange(of: afterPhotoItem) { _, newValue in
                Task {
                    let data = try? await newValue?.loadTransferable(type: Data.self)
                    await MainActor.run {
                        viewModel.updateAfterPhotoData(data)
                    }
                }
            }
        }
    }
}
