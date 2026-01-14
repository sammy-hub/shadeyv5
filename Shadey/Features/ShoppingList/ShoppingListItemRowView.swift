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
        ListRowView(
            systemImage: item.isPinned ? "pin.fill" : "cart",
            title: item.product?.displayName ?? "Product",
            subtitle: subtitleText
        ) {
            if item.isChecked {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.tint)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("shoppingListItem_\(item.id.uuidString)")
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            if item.isChecked {
                Button("Undo", systemImage: "arrow.uturn.backward") {
                    onUndo()
                }
            } else {
                Button("Purchased", systemImage: "checkmark") {
                    onPurchased()
                }
                .tint(.green)
            }
            
            Button("Edit", systemImage: "pencil") {
                onEdit()
            }
        }
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button("Restock", systemImage: "cart.badge.plus") {
                onRestock()
            }
            .tint(.blue)
            
            Button(item.isPinned ? "Unpin" : "Pin", systemImage: item.isPinned ? "pin.slash" : "pin") {
                onTogglePin()
            }
        }
        .contextMenu {
            Button("Restock Now", systemImage: "cart.badge.plus") {
                onRestock()
            }
            Button(item.isPinned ? "Unpin" : "Pin", systemImage: item.isPinned ? "pin.slash" : "pin") {
                onTogglePin()
            }
            Button("Edit", systemImage: "square.and.pencil") {
                onEdit()
            }
        }
    }
    
    private var subtitleText: String {
        var parts: [String] = []
        parts.append("Need \(item.quantityNeeded.formatted(AppFormatters.decimal)) \(item.product?.resolvedUnit.displayName ?? "")")
        parts.append(item.reason.detailText)
        if let note = item.note, !note.isEmpty {
            parts.append(note)
        }
        return parts.joined(separator: " • ")
    }
}
