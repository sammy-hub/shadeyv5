import Foundation

struct ProductTypeDefinition: Identifiable, Hashable {
    let id: String
    let name: String
    let defaultRatio: Double
    let isDeveloper: Bool
    let isBuiltIn: Bool
}
