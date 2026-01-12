import Foundation

struct ShoppingListBrandGroup: Identifiable {
    let id: String
    let brand: String
    let lineGroups: [ShoppingListLineGroup]
}

struct ShoppingListLineGroup: Identifiable {
    let id: String
    let name: String
    let typeGroups: [ShoppingListTypeGroup]
}

struct ShoppingListTypeGroup: Identifiable {
    let id: String
    let name: String
    let items: [ShoppingListItem]
}
