import Foundation
import Observation

@MainActor
@Observable
final class AppData {
    let persistence: PersistenceController
    let productTypeStore: ProductTypeStore
    let inventoryStore: InventoryStore
    let clientsStore: ClientsStore
    let shoppingListStore: ShoppingListStore

    init(persistence: PersistenceController = .shared) {
        self.persistence = persistence
        self.productTypeStore = ProductTypeStore()
        let context = persistence.viewContext
        let shoppingListStore = ShoppingListStore(context: context)
        self.shoppingListStore = shoppingListStore
        let inventoryStore = InventoryStore(context: context, shoppingListStore: shoppingListStore, productTypeStore: productTypeStore)
        self.inventoryStore = inventoryStore
        self.clientsStore = ClientsStore(context: context, inventoryStore: inventoryStore)
    }
}
