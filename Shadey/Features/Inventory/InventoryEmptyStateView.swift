import SwiftUI

struct InventoryEmptyStateView: View {
    let searchText: String
    let hasFilters: Bool
    let onAdd: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: "plus.circle")
        } description: {
            Text(message)
        } actions: {
            Button("Add Product", systemImage: "plus") {
                onAdd()
            }
            .buttonStyle(.glass)
        }
        .padding(.vertical, DesignSystem.Spacing.xxLarge)
    }

    private var title: String {
        if hasFilters || !searchText.isEmpty {
            return "No Matching Products"
        }
        return "No Inventory Yet"
    }

    private var message: String {
        if hasFilters || !searchText.isEmpty {
            return "Try clearing filters or searching with a different term."
        }
        return "Add your first product to start tracking stock and costs."
    }
}
