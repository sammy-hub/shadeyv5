import SwiftUI

struct FormulaSummarySectionView: View {
    @Bindable var viewModel: ServiceEditorViewModel
    let formula: ServiceFormulaDraft

    var body: some View {
        let unitLabel = viewModel.displayUnitLabel()
        let colorAmount = viewModel.displayColorAmount(for: formula)
        let developerAmount = viewModel.displayDeveloperAmount(for: formula)
        let mixAmount = viewModel.totalMixAmount(for: formula)
        let totalCost = viewModel.totalCost(for: formula)

        return Section("Summary") {
            LabeledContent("Color Amount") {
                Text("\(colorAmount.formatted(.number.precision(.fractionLength(2)))) \(unitLabel)")
            }
            LabeledContent("Developer Amount") {
                Text("\(developerAmount.formatted(.number.precision(.fractionLength(2)))) \(unitLabel)")
            }
            LabeledContent("Total Mix") {
                Text("\(mixAmount.formatted(.number.precision(.fractionLength(2)))) \(unitLabel)")
            }
            LabeledContent("Estimated Cost") {
                Text(totalCost, format: CurrencyFormat.inventory)
            }
        }
    }
}
