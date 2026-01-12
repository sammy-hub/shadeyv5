import SwiftUI

struct ProductEditorPricingSectionView: View {
    @Bindable var viewModel: ProductEditorViewModel

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                SectionHeaderView(title: "Pricing", subtitle: "Keep costs aligned between services and purchasing.")

                NumberEntryRow(
                    "Quantity per unit",
                    helper: "How many \(viewModel.draft.unit.displayName) come in a single bottle or tube.",
                    value: $viewModel.draft.quantityPerUnit,
                    format: .number
                )

                NumberEntryRow(
                    "Purchase price",
                    helper: "The amount you paid for the complete unit.",
                    value: $viewModel.draft.purchasePrice,
                    format: CurrencyFormat.inventory,
                    keyboardType: .decimalPad
                )

                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                    Text("Cost per \(viewModel.draft.unit.displayName)")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                    Text(costPerUnitText)
                        .font(DesignSystem.Typography.headline)
                        .foregroundStyle(DesignSystem.textPrimary)
                    Text("Used for estimating formulas and reports.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }

                if let hint = viewModel.pricingHint {
                    Text(hint)
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
            }
        }
    }

    private var costPerUnitText: String {
        guard let costPerUnit = viewModel.costPerUnit else {
            return "--"
        }
        return costPerUnit.formatted(CurrencyFormat.inventory)
    }
}
