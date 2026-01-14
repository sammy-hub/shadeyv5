import SwiftUI

struct FormulaEditorView: View {
    @Bindable var viewModel: ServiceEditorViewModel
    let formulaId: UUID

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        if let formula = viewModel.formula(for: formulaId) {
            Form {
                FormulaDetailsSectionView(viewModel: viewModel, formula: formula)
                FormulaQuickSearchSectionView(viewModel: viewModel, formulaId: formula.id)
                FormulaSelectionListView(viewModel: viewModel, formula: formula)
                FormulaDeveloperSectionView(viewModel: viewModel, formula: formula)
                FormulaSummarySectionView(viewModel: viewModel, formula: formula)
                FormulaRemoveSectionView(
                    canRemove: viewModel.draft.formulas.count > 1,
                    onRemove: {
                        viewModel.removeFormula(formula.id)
                        dismiss()
                    }
                )
            }
            .navigationTitle(formula.name)
            .navigationBarTitleDisplayMode(.inline)
        } else {
            ContentUnavailableView {
                Label("Formula Missing", systemImage: "exclamationmark.triangle")
            } description: {
                Text("This formula is no longer available.")
            }
        }
    }
}
