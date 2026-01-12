import Foundation

enum InventoryAddMode: String, CaseIterable, Identifiable {
    case fast
    case bulk

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .fast:
            return "Fast Add"
        case .bulk:
            return "Bulk Add"
        }
    }
}
