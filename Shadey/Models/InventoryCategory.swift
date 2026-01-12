import Foundation

enum InventoryCategory: String, CaseIterable, Identifiable {
    case hairColor
    case lightener
    case developer
    case treatment

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .hairColor:
            return "Hair Color"
        case .lightener:
            return "Lightener"
        case .developer:
            return "Developer"
        case .treatment:
            return "Treatment"
        }
    }

    var systemImage: String {
        switch self {
        case .hairColor:
            return "paintbrush"
        case .lightener:
            return "sparkles"
        case .developer:
            return "drop.fill"
        case .treatment:
            return "cross.case.fill"
        }
    }
}

struct InventoryCategorySummary: Identifiable {
    let category: InventoryCategory
    let productCount: Int
    let lineCount: Int
    let lowStockCount: Int
    let totalValue: Double

    var id: String { category.id }
}
