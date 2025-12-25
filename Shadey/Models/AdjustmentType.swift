import Foundation

enum AdjustmentType: String, CaseIterable, Identifiable {
    case add
    case deduct

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .add:
            "Add"
        case .deduct:
            "Use"
        }
    }

    var multiplier: Double {
        switch self {
        case .add:
            1
        case .deduct:
            -1
        }
    }
}
