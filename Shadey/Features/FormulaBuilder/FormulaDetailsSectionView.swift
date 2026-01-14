import SwiftUI

struct FormulaDetailsSectionView: View {
    @Bindable var viewModel: ServiceEditorViewModel
    let formula: ServiceFormulaDraft

    var body: some View {
        let nameBinding = Binding<String>(
            get: { formula.name },
            set: { viewModel.updateFormulaName($0, for: formula.id) }
        )

        return Section {
            TextField("Name", text: nameBinding)
                .accessibilityIdentifier("formulaNameField")
            LabeledContent("Unit") {
                Text(viewModel.displayUnitLabel())
            }
        } header: {
            Text("Formula Details")
        } footer: {
            Text("Name this mix so it is easy to find later.")
        }
    }
}




