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

    func converted(_ value: Double, to unit: UnitType) -> Double {
        guard self != unit else { return value }
        let gramsPerOunce = 28.3495
        switch (self, unit) {
        case (.ounces, .grams):
            return value * gramsPerOunce
        case (.grams, .ounces):
            return value / gramsPerOunce
        default:
            return value
        }
    }
}
