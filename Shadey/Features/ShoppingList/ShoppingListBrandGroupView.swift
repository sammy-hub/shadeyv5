import SwiftUI

struct ShoppingListBrandGroupView: View {
    let group: ShoppingListBrandGroup
    let autoRestockOnPurchase: Bool
    let onPurchased: (ShoppingListItem) -> Void
    let onRestock: (ShoppingListItem) -> Void
    let onEdit: (ShoppingListItem) -> Void
    let onTogglePin: (ShoppingListItem) -> Void
    let onUndo: (ShoppingListItem) -> Void

    var body: some View {
        Section(group.brand) {
            ForEach(group.lineGroups) { lineGroup in
                if !lineGroup.name.isEmpty {
                    Text(lineGroup.name)
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
                ForEach(lineGroup.typeGroups) { typeGroup in
                    Text(typeGroup.name)
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                    ForEach(typeGroup.items, id: \.id) { item in
                        ShoppingListItemRowView(
                            item: item,
                            autoRestockOnPurchase: autoRestockOnPurchase,
                            onPurchased: { onPurchased(item) },
                            onRestock: { onRestock(item) },
                            onEdit: { onEdit(item) },
                            onTogglePin: { onTogglePin(item) },
                            onUndo: { onUndo(item) }
                        )
                    }
                }
            }
        }
    }
}
