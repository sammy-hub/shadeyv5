import Foundation
import Observation

@MainActor
@Observable
final class ShoppingListViewModel {
    private let store: ShoppingListStore

    init(store: ShoppingListStore) {
        self.store = store
    }

    var items: [ShoppingListItem] {
        store.items
    }

    func restock(item: ShoppingListItem) {
        store.restock(item: item)
    }

    func refresh() {
        store.reload()
    }
}
