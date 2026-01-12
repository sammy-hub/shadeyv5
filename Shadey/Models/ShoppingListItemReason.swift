import Foundation

enum ShoppingListItemReason: String, CaseIterable, Identifiable, Codable {
    case depleted
    case lowStock
    case manual

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .depleted:
            return "Depleted"
        case .lowStock:
            return "Low stock"
        case .manual:
            return "Manual"
        }
    }

    var detailText: String {
        switch self {
        case .depleted:
            return "Out of stock"
        case .lowStock:
            return "Below threshold"
        case .manual:
            return "Added manually"
        }
    }
}
