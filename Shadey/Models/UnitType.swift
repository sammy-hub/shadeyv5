import Foundation

enum UnitType: String, CaseIterable, Identifiable {
    case ounces
    case grams

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .ounces:
            "oz"
        case .grams:
            "g"
        }
    }
}
