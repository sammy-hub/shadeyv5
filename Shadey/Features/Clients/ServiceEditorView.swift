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
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sectionSpacing) {
                    ServiceDetailsSectionView(viewModel: viewModel)

                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                        SectionHeaderView(title: "Formulas", subtitle: "Add one or more formulas for this service.")

                        ForEach(viewModel.draft.formulas) { formula in
                            ServiceFormulaEditorCardView(
                                viewModel: viewModel,
                                formula: formula,
                                canRemove: viewModel.draft.formulas.count > 1,
                                onRemove: { viewModel.removeFormula(formula.id) }
                            )
                        }

                        Button("Add Formula", systemImage: "plus") {
                            viewModel.addFormula()
                        }
                        .buttonStyle(.bordered)
                    }

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

                    FormulaSummaryBarView(
                        formulaCount: viewModel.draft.formulas.count,
                        totalMixAmount: viewModel.totalServiceMixAmount,
                        unitLabel: viewModel.totalServiceUnitLabel(),
                        showsMixedUnits: viewModel.hasMixedUnits,
                        totalCost: viewModel.totalServiceCost
                    )
                    .padding(.top, DesignSystem.Spacing.medium)
            }
            .padding(.horizontal, DesignSystem.Spacing.pagePadding)
            .padding(.vertical, DesignSystem.Spacing.large)
        }
        .background(DesignSystem.background)
        .scrollIndicators(.hidden)
        .navigationTitle("New Service")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    onSave(viewModel.finalizedDraft())
                    dismiss()
                }
                .disabled(viewModel.draft.formulas.allSatisfy { $0.selections.isEmpty })
            }
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
