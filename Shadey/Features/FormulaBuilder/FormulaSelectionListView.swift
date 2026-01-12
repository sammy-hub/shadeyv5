import SwiftUI

struct FormulaSelectionListView: View {
    @Bindable var viewModel: ServiceEditorViewModel
    let formula: ServiceFormulaDraft

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            SectionHeaderView(title: "Formula Mix", subtitle: "Adjust amounts and ratios inline.")

            if formula.selections.isEmpty {
                Text("Add products to build this formula.")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            } else {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
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
                            onRemove: {
                                viewModel.toggleSelection(for: selection.product, formulaId: formula.id)
                            }
                        )
                    }
                }
            }
        }
    }
}
