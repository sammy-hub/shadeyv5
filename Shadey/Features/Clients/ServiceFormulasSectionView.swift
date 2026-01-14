import SwiftUI

struct ServiceFormulasSectionView: View {
    @Bindable var viewModel: ServiceEditorViewModel

    var body: some View {
        SwiftUI.Section {
            ForEach(viewModel.draft.formulas) { formula in
                let mixAmount = viewModel.totalMixAmount(for: formula)
                let unitLabel = viewModel.activeUnitLabel(for: formula)
                let totalCost = viewModel.totalCost(for: formula)
                let productCount = formula.selections.count

                NavigationLink(value: formula.id) {
                    ServiceFormulaRowView(
                        name: formula.name,
                        productCount: productCount,
                        mixAmount: mixAmount,
                        unitLabel: unitLabel,
                        totalCost: totalCost
                    )
                }
                .accessibilityIdentifier("formulaRow_\(formula.id.uuidString)")
            }

            Button("Add Formula", systemImage: "plus") {
                viewModel.addFormula()
            }
            .accessibilityIdentifier("addFormulaButton")
        } header: {
            Text("Formulas")
        } footer: {
            Text("Add one or more formulas for this service.")
        }
    }
}
