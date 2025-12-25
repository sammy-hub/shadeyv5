import SwiftUI

struct ProductEditorPricingSectionView: View {
    @Bindable var viewModel: ProductEditorViewModel

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                SectionHeaderView(title: "Pricing", subtitle: "Keep costs consistent across services.")

                FieldContainerView {
                    OptionalNumberField("Quantity per Unit", value: $viewModel.draft.quantityPerUnit, format: .number)
                }

                FieldContainerView {
                    OptionalNumberField("Purchase Price", value: $viewModel.draft.purchasePrice, format: CurrencyFormat.inventory)
                }

                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                    Text("Cost per \(viewModel.draft.unit.displayName)")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                    Text(costPerUnitText)
                        .font(DesignSystem.Typography.headline)
                        .foregroundStyle(DesignSystem.textPrimary)
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
