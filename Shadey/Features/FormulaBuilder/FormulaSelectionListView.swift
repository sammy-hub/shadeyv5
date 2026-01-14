import SwiftUI

struct FormulaSelectionListView: View {
    @Bindable var viewModel: ServiceEditorViewModel
    let formula: ServiceFormulaDraft

    var body: some View {
        SwiftUI.Section {
            if formula.selections.isEmpty {
                Text("Add products to build this formula.")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            } else {
                ForEach(formula.selections) { selection in
                    FormulaSelectionRowView(
                        selection: selection,
                        unitLabel: viewModel.displayUnitLabel(),
                        amount: Binding(
                            get: { viewModel.displayAmount(for: selection) },
                            set: { viewModel.updateDisplayAmount($0, for: selection, formulaId: formula.id) }
                        ),
                        ratioPart: Binding(
                            get: { selection.ratioPart },
                            set: { viewModel.updateRatioPart(for: selection, ratioPart: $0, formulaId: formula.id) }
                        ),
                        deductionMode: Binding(
                            get: { selection.deductionMode },
                            set: { viewModel.updateDeductionMode(for: selection, mode: $0, formulaId: formula.id) }
                        )
                    )
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button("Remove", role: .destructive) {
                            viewModel.toggleSelection(for: selection.product, formulaId: formula.id)
                        }
                    }
                    .accessibilityIdentifier("formulaSelectionRow_\(selection.id.uuidString)")
                }
            }
        } header: {
            Text("Formula Mix")
        } footer: {
            Text("Set amounts and ratios for each product.")
        }
    }
}
