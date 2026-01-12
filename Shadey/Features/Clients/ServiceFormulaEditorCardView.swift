import SwiftUI

struct ServiceFormulaEditorCardView: View {
    @Bindable var viewModel: ServiceEditorViewModel
    let formula: ServiceFormulaDraft
    let canRemove: Bool
    let onRemove: () -> Void

    var body: some View {
        let nameBinding = Binding<String>(
            get: { formula.name },
            set: { viewModel.updateFormulaName($0, for: formula.id) }
        )

        return SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                HStack(alignment: .top, spacing: DesignSystem.Spacing.small) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                        Text("Formula name")
                            .font(DesignSystem.Typography.caption)
                            .foregroundStyle(DesignSystem.textSecondary)
                        TextField("Formula name", text: nameBinding)
                            .textFieldStyle(.roundedBorder)
                    }

                    if canRemove {
                        Button("Remove", systemImage: "trash") {
                            onRemove()
                        }
                        .buttonStyle(.bordered)
                    }
                }

                FormulaQuickSearchSectionView(viewModel: viewModel, formula: formula)

                FormulaSelectionListView(viewModel: viewModel, formula: formula)

                FormulaDeveloperSectionView(viewModel: viewModel, formula: formula)

                if !formula.selections.isEmpty {
                    let totalCost = viewModel.totalCost(for: formula)
                    Text("Formula total: \(totalCost.formatted(CurrencyFormat.inventory))")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
            }
        }
    }
}
