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
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            Text(group.brand)
                .font(DesignSystem.Typography.headline)
                .foregroundStyle(DesignSystem.textPrimary)

            ForEach(group.lineGroups) { lineGroup in
                ShoppingListLineGroupView(
                    group: lineGroup,
                    autoRestockOnPurchase: autoRestockOnPurchase,
                    onPurchased: onPurchased,
                    onRestock: onRestock,
                    onEdit: onEdit,
                    onTogglePin: onTogglePin,
                    onUndo: onUndo
                )
            }
        }
        .padding(.bottom, DesignSystem.Spacing.small)
    }
}

struct ShoppingListLineGroupView: View {
    let group: ShoppingListLineGroup
    let autoRestockOnPurchase: Bool
    let onPurchased: (ShoppingListItem) -> Void
    let onRestock: (ShoppingListItem) -> Void
    let onEdit: (ShoppingListItem) -> Void
    let onTogglePin: (ShoppingListItem) -> Void
    let onUndo: (ShoppingListItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
            Text(group.name)
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(DesignSystem.textSecondary)

            ForEach(group.typeGroups) { typeGroup in
                ShoppingListTypeGroupView(
                    group: typeGroup,
                    autoRestockOnPurchase: autoRestockOnPurchase,
                    onPurchased: onPurchased,
                    onRestock: onRestock,
                    onEdit: onEdit,
                    onTogglePin: onTogglePin,
                    onUndo: onUndo
                )
            }
        }
        .padding(.leading, DesignSystem.Spacing.small)
    }
}

struct ShoppingListTypeGroupView: View {
    let group: ShoppingListTypeGroup
    let autoRestockOnPurchase: Bool
    let onPurchased: (ShoppingListItem) -> Void
    let onRestock: (ShoppingListItem) -> Void
    let onEdit: (ShoppingListItem) -> Void
    let onTogglePin: (ShoppingListItem) -> Void
    let onUndo: (ShoppingListItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
            Text(group.name)
                .font(DesignSystem.Typography.caption)
                .foregroundStyle(DesignSystem.textSecondary)

            ForEach(group.items, id: \.id) { item in
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
        .padding(.leading, DesignSystem.Spacing.small)
    }
}
