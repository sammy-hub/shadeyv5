import Foundation
import Observation

struct CustomProductType: Identifiable, Codable, Hashable {
    var id: String
    var name: String
    var defaultRatio: Double
}

struct ProductTypeOverride: Codable, Hashable {
    var name: String
    var defaultRatio: Double
}

@MainActor
@Observable
final class ProductTypeStore {
    private static let customTypesKey = "customProductTypes"
    private static let overridesKey = "productTypeOverrides"

    private var customTypes: [CustomProductType] {
        didSet {
            saveCustomTypes()
        }
    }

    private var overrides: [String: ProductTypeOverride] {
        didSet {
            saveOverrides()
        }
    }

    init() {
        customTypes = Self.loadCustomTypes()
        overrides = Self.loadOverrides()
    }

    var builtInDefinitions: [ProductTypeDefinition] {
        ProductType.allCases.map { type in
            let override = overrides[type.rawValue]
            let name = override?.name ?? type.displayName
            let ratio = override?.defaultRatio ?? type.defaultRatio
            return ProductTypeDefinition(
                id: type.rawValue,
                name: name,
                defaultRatio: ratio,
                isDeveloper: type == .developer,
                isBuiltIn: true
            )
        }
    }

    var customDefinitions: [ProductTypeDefinition] {
        let definitions = customTypes.map { type in
            ProductTypeDefinition(
                id: type.id,
                name: type.name,
                defaultRatio: type.defaultRatio,
                isDeveloper: false,
                isBuiltIn: false
            )
        }
        return definitions.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }

    var allDefinitions: [ProductTypeDefinition] {
        let combined = builtInDefinitions + customDefinitions
        return combined.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }

    func definition(for id: String) -> ProductTypeDefinition {
        if let builtIn = builtInDefinitions.first(where: { $0.id == id }) {
            return builtIn
        }
        if let custom = customDefinitions.first(where: { $0.id == id }) {
            return custom
        }
        return ProductTypeDefinition(
            id: id,
            name: id,
            defaultRatio: ProductType.permanent.defaultRatio,
            isDeveloper: false,
            isBuiltIn: false
        )
    }

    func displayName(for id: String) -> String {
        definition(for: id).name
    }

    func defaultRatio(for id: String) -> Double {
        definition(for: id).defaultRatio
    }

    func isDeveloperType(_ id: String) -> Bool {
        definition(for: id).isDeveloper
    }

    func addCustomType(name: String, defaultRatio: Double) -> ProductTypeDefinition {
        let normalizedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let newType = CustomProductType(id: UUID().uuidString, name: normalizedName, defaultRatio: defaultRatio)
        customTypes.append(newType)
        return definition(for: newType.id)
    }

    func updateType(_ definition: ProductTypeDefinition) {
        if definition.isBuiltIn {
            overrides[definition.id] = ProductTypeOverride(name: definition.name, defaultRatio: definition.defaultRatio)
            return
        }
        guard let index = customTypes.firstIndex(where: { $0.id == definition.id }) else { return }
        customTypes[index].name = definition.name
        customTypes[index].defaultRatio = definition.defaultRatio
    }

    func deleteType(_ definition: ProductTypeDefinition) {
        if definition.isBuiltIn {
            overrides.removeValue(forKey: definition.id)
            return
        }
        customTypes.removeAll { $0.id == definition.id }
    }

    func resetBuiltIn(_ id: String) {
        overrides.removeValue(forKey: id)
    }

    private static func loadCustomTypes() -> [CustomProductType] {
        guard let data = UserDefaults.standard.data(forKey: customTypesKey) else { return [] }
        return (try? JSONDecoder().decode([CustomProductType].self, from: data)) ?? []
    }

    private static func loadOverrides() -> [String: ProductTypeOverride] {
        guard let data = UserDefaults.standard.data(forKey: overridesKey) else { return [:] }
        return (try? JSONDecoder().decode([String: ProductTypeOverride].self, from: data)) ?? [:]
    }

    private func saveCustomTypes() {
        let data = try? JSONEncoder().encode(customTypes)
        UserDefaults.standard.set(data, forKey: Self.customTypesKey)
    }

    private func saveOverrides() {
        let data = try? JSONEncoder().encode(overrides)
        UserDefaults.standard.set(data, forKey: Self.overridesKey)
    }
}
