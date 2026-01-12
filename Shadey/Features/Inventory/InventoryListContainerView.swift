import SwiftUI

struct InventoryListContainerView: View {
    @Bindable var viewModel: InventoryViewModel
    @Binding var showingAddProduct: Bool
    @Binding var editingProduct: Product?
    @Binding var adjustingProduct: Product?
    @Binding var deletingProduct: Product?

    var body: some View {
        List {
            Section {
                InventoryOverviewGridView(
                    totalValue: viewModel.totalValue,
                    shadeCount: viewModel.totalShadeCount,
                    lowStockCount: viewModel.lowStockCount,
                    overstockCount: viewModel.overstockCount
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(
                    top: DesignSystem.Spacing.small,
                    leading: DesignSystem.Spacing.pagePadding,
                    bottom: DesignSystem.Spacing.small,
                    trailing: DesignSystem.Spacing.pagePadding
                ))
            }

            Section {
                InventoryListView(
                    viewModel: viewModel,
                    onEdit: { editingProduct = $0 },
                    onDeduct: { adjustingProduct = $0 },
                    onDelete: { deletingProduct = $0 },
                    onAdd: { showingAddProduct = true }
                )
            }
        }
    }
}
