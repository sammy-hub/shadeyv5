import SwiftUI

struct ShoppingListItemRowView: View {
    let item: ShoppingListItem
    let autoRestockOnPurchase: Bool
    let onPurchased: () -> Void
    let onRestock: () -> Void
    let onEdit: () -> Void
    let onTogglePin: () -> Void
    let onUndo: () -> Void

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                        Text(item.product?.displayName ?? "Product")
                            .font(DesignSystem.Typography.headline)
                            .foregroundStyle(DesignSystem.textPrimary)
                        Text("Need \(item.quantityNeeded.formatted(.number)) \(item.product?.resolvedUnit.displayName ?? "")")
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                    Spacer()
                    if item.isPinned {
                        Image(systemName: "pin.fill")
                            .foregroundStyle(DesignSystem.accent)
                    }
                }

                HStack(spacing: DesignSystem.Spacing.small) {
                    ShoppingListReasonTagView(reason: item.reason)
                    Text(item.reason.detailText)
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }

                if let note = item.note, !note.isEmpty {
                    Text(note)
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }

                HStack(spacing: DesignSystem.Spacing.small) {
                    if item.isChecked {
                        Button("Undo", systemImage: "arrow.uturn.backward") {
                            onUndo()
                        }
                        .buttonStyle(.bordered)
                    } else {
                        Button("Purchased", systemImage: autoRestockOnPurchase ? "cart.badge.checkmark" : "checkmark") {
                            onPurchased()
                        }
                        .buttonStyle(.borderedProminent)
                    }

                    Menu {
                        Button("Restock Now", systemImage: "cart.badge.plus") {
                            onRestock()
                        }
                        Button(item.isPinned ? "Unpin" : "Pin", systemImage: item.isPinned ? "pin.slash" : "pin") {
                            onTogglePin()
                        }
                        Button("Edit", systemImage: "square.and.pencil") {
                            onEdit()
                        }
                    } label: {
                        Label("More", systemImage: "ellipsis.circle")
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}
