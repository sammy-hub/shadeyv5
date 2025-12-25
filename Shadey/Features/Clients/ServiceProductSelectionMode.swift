import Foundation

enum ServiceProductSelectionMode: String, CaseIterable, Identifiable {
    case grouped
    case all

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .grouped:
            return "Grouped"
        case .all:
            return "All"
        }
    }
}
