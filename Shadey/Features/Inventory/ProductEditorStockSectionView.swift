import SwiftUI

struct ProductEditorStockSectionView: View {
    @Bindable var viewModel: ProductEditorViewModel

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                SectionHeaderView(title: "Stock", subtitle: "Track inventory levels and alerts.")

                FieldContainerView {
                    OptionalNumberField("Current Stock", value: $viewModel.draft.stockQuantity, format: .number)
                }

                FieldContainerView {
                    OptionalNumberField("Low Stock Alert", value: $viewModel.draft.lowStockThreshold, format: .number)
                }

                FieldContainerView {
                    OptionalNumberField("Overstock Alert", value: $viewModel.draft.overstockThreshold, format: .number)
                }
            }
        }
    }
}
