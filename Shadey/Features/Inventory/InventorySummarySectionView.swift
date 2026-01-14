import SwiftUI

struct InventorySummarySectionView: View {
    @Bindable var viewModel: InventoryViewModel

    var body: some View {
        Section("Overview") {
            LabeledContent("Total Value") {
                Text(viewModel.totalValue, format: CurrencyFormat.inventory)
            }
            LabeledContent("Products", value: "\(viewModel.totalShadeCount)")

            if viewModel.lowStockCount > 0 {
                LabeledContent("Low Stock") {
                    Text("\(viewModel.lowStockCount)")
                        .foregroundStyle(DesignSystem.warning)
                }
            }

            if viewModel.overstockCount > 0 {
                LabeledContent("Overstock") {
                    Text("\(viewModel.overstockCount)")
                        .foregroundStyle(DesignSystem.positive)
                }
            }
        }
    }
}
