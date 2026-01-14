import SwiftUI

struct ServiceSummarySectionView: View {
    @Bindable var viewModel: ServiceEditorViewModel

    private var mixText: String {
        if viewModel.hasMixedUnits {
            return "Mixed units"
        }
        return "\(viewModel.totalServiceMixAmount.formatted(.number.precision(.fractionLength(2)))) \(viewModel.totalServiceUnitLabel())"
    }

    var body: some View {
        Section {
            LabeledContent("Formulas", value: "\(viewModel.draft.formulas.count)")
            LabeledContent("Total Mix") {
                Text(mixText)
            }
            LabeledContent("Total Cost") {
                Text(viewModel.totalServiceCost, format: CurrencyFormat.inventory)
            }
        } header: {
            Text("Summary")
        }
    }
}
