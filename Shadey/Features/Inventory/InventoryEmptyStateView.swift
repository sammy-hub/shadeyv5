import SwiftUI

struct InventoryEmptyStateView: View {
    let searchText: String
    let hasFilters: Bool
    let onAdd: () -> Void

    var body: some View {
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let isFiltered = hasFilters || !trimmedSearch.isEmpty
        let title = isFiltered ? "No Matching Products" : "No Inventory Yet"
        let message = isFiltered
            ? "Try clearing filters or searching with a different term."
            : "Add your first product to start tracking stock and costs."

        return ContentUnavailableView {
            Label(title, systemImage: "tray")
        } description: {
            Text(message)
        } actions: {
            Button("Add Product", systemImage: "plus") {
                onAdd()
            }
            .buttonStyle(.borderedProminent)
            .accessibilityIdentifier("addProductEmptyStateButton")
        }
        .padding(.vertical, DesignSystem.Spacing.xxLarge)
    }
}
