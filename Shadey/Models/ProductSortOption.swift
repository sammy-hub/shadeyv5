import Foundation

enum ProductSortOption: String, CaseIterable, Identifiable {
    case name
    case brand
    case stockLevel
    case productType

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .name:
            "Name"
        case .brand:
            "Brand"
        case .productType:
            "Type"
        case .stockLevel:
            "Stock"
        }
    }
}
