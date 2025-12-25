import Foundation

enum ProductType: String, CaseIterable, Identifiable {
    case permanent
    case demiPermanent
    case semiPermanent
    case developer
    case lightener
    case treatment

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .permanent:
            "Permanent"
        case .demiPermanent:
            "Demi-Permanent"
        case .semiPermanent:
            "Semi-Permanent"
        case .developer:
            "Developer"
        case .lightener:
            "Lightener"
        case .treatment:
            "Treatment"
        }
    }

    var defaultRatio: Double {
        switch self {
        case .permanent:
            1
        case .demiPermanent:
            1.5
        case .semiPermanent:
            1
        case .developer:
            0
        case .lightener:
            2
        case .treatment:
            0
        }
    }
}
