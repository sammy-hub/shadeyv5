import SwiftUI

struct ProductEditorStockSectionView: View {
    @Bindable var viewModel: ProductEditorViewModel

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                SectionHeaderView(title: "Stock", subtitle: "Track inventory levels and alerts.")

                NumberEntryRow(
                    "Current Stock",
                    helper: "Total units you currently have on hand.",
                    unitLabel: viewModel.draft.unit.displayName,
                    value: $viewModel.draft.stockQuantity,
                    format: .number
                )

                DisclosureGroup("Alert settings") {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        NumberEntryRow(
                            "Low Stock Alert",
                            helper: "Trigger warnings so you don’t run out.",
                            value: $viewModel.draft.lowStockThreshold,
                            format: .number
                        )

                        NumberEntryRow(
                            "Overstock Alert",
                            helper: "Avoid carrying too much inventory.",
                            value: $viewModel.draft.overstockThreshold,
                            format: .number
                        )

                        Toggle("Don't auto-add to shopping list", isOn: $viewModel.draft.autoAddDisabled)
                            .toggleStyle(.switch)
                    }
                    .padding(.top, DesignSystem.Spacing.small)
                }
            }
        }
    }
}
