import Foundation

enum InventoryDeductionMode: String, CaseIterable, Identifiable, Codable {
    case openStock
    case newUnit

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .openStock:
            return "Open stock"
        case .newUnit:
            return "New unit"
        }
    }

    var helperText: String {
        switch self {
        case .openStock:
            return "Deduct the exact amount used."
        case .newUnit:
            return "Deduct a full unit for unopened stock."
        }
    }
}
