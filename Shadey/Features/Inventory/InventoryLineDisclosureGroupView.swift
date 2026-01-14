import SwiftUI

struct InventoryLineDisclosureGroupView: View {
    @Bindable var viewModel: InventoryViewModel
    let section: InventoryLineSection
    let itemLabel: String
    @Binding var isExpanded: Bool
    let onEdit: (Product) -> Void
    let onDeduct: (Product) -> Void
    let onDelete: (Product) -> Void

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            ForEach(section.shades, id: \.id) { product in
                let subtitle = viewModel.productSubtitle(for: product)
                let stockText = viewModel.stockText(for: product)
                let unitCostText = viewModel.unitCostText(for: product)

                NavigationLink(value: product.id) {
                    InventoryTableRowView(
                        title: product.shadeLabel,
                        subtitle: subtitle,
                        stockText: stockText,
                        unitCostText: unitCostText,
                        stockStatus: viewModel.stockStatus(for: product)
                    )
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    Button("Deduct", systemImage: "minus.circle") {
                        onDeduct(product)
                    }
                    .tint(DesignSystem.warning)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button("Edit", systemImage: "pencil") {
                        onEdit(product)
                    }
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        onDelete(product)
                    }
                }
            }
        } label: {
            InventoryLineHeaderView(section: section, itemLabel: itemLabel)
        }
    }
}
