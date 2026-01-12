import Foundation
import Observation

@MainActor
@Observable
final class ColorLineEditorViewModel {
    private let store: InventoryStore
    var lineDraft: ColorLineDraft
    var productTypeQuery: String
    var selectedLine: ColorLine?
    var developerRatioDeveloperPart: Double? {
        didSet {
            updateDeveloperRatioFromParts()
        }
    }
    var developerRatioColorPart: Double? {
        didSet {
            updateDeveloperRatioFromParts()
        }
    }

    init(store: InventoryStore, line: ColorLine? = nil) {
        let initialSelectedLine = line
        var initialDraft: ColorLineDraft
        if let line {
            initialDraft = ColorLineDraft(colorLine: line)
        } else {
            let defaultTypeId = ProductType.permanent.rawValue
            let defaultRatio = store.productTypeStore.defaultRatio(for: defaultTypeId)
            initialDraft = ColorLineDraft(productTypeId: defaultTypeId, defaultDeveloperRatio: defaultRatio)
        }

        let isDeveloperType = store.productTypeStore.isDeveloperType(initialDraft.productTypeId)
        if isDeveloperType {
            initialDraft.defaultDeveloperRatio = nil
            initialDraft.defaultDeveloperId = nil
        }
        let initialProductTypeQuery = store.productTypeStore.displayName(for: initialDraft.productTypeId)
        let initialRatio = isDeveloperType ? nil : initialDraft.defaultDeveloperRatio
        let initialDeveloperPart = initialRatio
        let initialColorPart = initialRatio == nil ? nil : 1.0

        self.store = store
        self.selectedLine = initialSelectedLine
        self.lineDraft = initialDraft
        self.productTypeQuery = initialProductTypeQuery
        self.developerRatioDeveloperPart = initialDeveloperPart
        self.developerRatioColorPart = initialColorPart
    }

    var availableBrands: [String] {
        let brands = Set(store.products.map(\.resolvedBrand))
        return brands.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }

    var brandSuggestions: [String] {
        filteredSuggestions(from: availableBrands, query: lineDraft.brand)
    }

    var lineSuggestions: [String] {
        let brand = trimmed(lineDraft.brand)
        guard !brand.isEmpty else { return [] }
        let lines = store.colorLines(for: brand)
        let names = Set(lines.map(\.name))
        return names.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }

    var typeSuggestions: [ProductTypeDefinition] {
        let query = trimmed(productTypeQuery)
        if query.isEmpty {
            return store.productTypeStore.allDefinitions
        }
        return store.productTypeStore.allDefinitions.filter { $0.name.localizedStandardContains(query) }
    }

    var developerOptions: [Product] {
        let brand = trimmed(lineDraft.brand)
        let developers = store.products.filter { $0.resolvedProductTypeId == ProductType.developer.rawValue }
        if brand.isEmpty {
            return developers.sorted { $0.displayName.localizedStandardCompare($1.displayName) == .orderedAscending }
        }
        let filtered = developers.filter { $0.resolvedBrand.localizedStandardCompare(brand) == .orderedSame }
        let sorted = filtered.sorted { $0.displayName.localizedStandardCompare($1.displayName) == .orderedAscending }
        return sorted.isEmpty ? developers : sorted
    }

    func developerLabel(for product: Product) -> String {
        if let strength = DeveloperStrength(rawValue: product.developerStrength) {
            return "\(product.displayName) (\(strength.displayName))"
        }
        return product.displayName
    }

    var isLineValid: Bool {
        !trimmed(lineDraft.brand).isEmpty && !trimmed(lineDraft.name).isEmpty
    }

    var isLineDeveloperType: Bool {
        store.productTypeStore.isDeveloperType(lineDraft.productTypeId)
    }

    var isLineDefaultsComplete: Bool {
        guard let quantity = lineDraft.quantityPerUnit, quantity > 0 else { return false }
        guard let price = lineDraft.purchasePrice, price >= 0 else { return false }
        if !store.productTypeStore.isDeveloperType(lineDraft.productTypeId) {
            guard let ratio = lineDraft.defaultDeveloperRatio, ratio > 0 else { return false }
        }
        return true
    }

    var lineCostPerUnit: Double? {
        guard let quantity = lineDraft.quantityPerUnit, quantity > 0,
              let price = lineDraft.purchasePrice else { return nil }
        return price / quantity
    }

    var lineDefaultsHint: String? {
        if lineDraft.quantityPerUnit == nil {
            return "Add the amount in each unit to calculate cost per unit."
        }
        if let quantity = lineDraft.quantityPerUnit, quantity <= 0 {
            return "Amount per unit must be greater than 0."
        }
        if lineDraft.purchasePrice == nil {
            return "Add a purchase price to calculate cost per unit."
        }
        if let price = lineDraft.purchasePrice, price < 0 {
            return "Purchase price can't be negative."
        }
        if !store.productTypeStore.isDeveloperType(lineDraft.productTypeId) {
            if lineDraft.defaultDeveloperRatio == nil {
                return "Add a developer ratio for this color line."
            }
            if let ratio = lineDraft.defaultDeveloperRatio, ratio <= 0 {
                return "Developer ratio must be greater than 0."
            }
        }
        return nil
    }

    func updateBrand(_ brand: String) {
        let normalized = trimmed(brand)
        let previous = trimmed(lineDraft.brand)
        if previous.localizedStandardCompare(normalized) != .orderedSame {
            lineDraft.name = ""
            lineDraft.defaultDeveloperId = nil
        }
        lineDraft.brand = brand
    }

    func updateLineName(_ name: String) {
        lineDraft.name = name
    }

    func updateProductTypeQuery(_ query: String) {
        productTypeQuery = query
        let match = store.productTypeStore.allDefinitions.first { type in
            type.name.localizedStandardCompare(trimmed(query)) == .orderedSame
        }
        if let match {
            updateProductType(match)
        }
    }

    func updateProductType(_ type: ProductTypeDefinition) {
        lineDraft.productTypeId = type.id
        productTypeQuery = type.name
        if type.isDeveloper {
            lineDraft.defaultDeveloperRatio = nil
            lineDraft.defaultDeveloperId = nil
            developerRatioDeveloperPart = nil
            developerRatioColorPart = nil
        } else if lineDraft.defaultDeveloperRatio == nil || lineDraft.defaultDeveloperRatio == 0 {
            lineDraft.defaultDeveloperRatio = type.defaultRatio
            developerRatioDeveloperPart = type.defaultRatio
            developerRatioColorPart = 1
        }
    }

    func save() {
        guard isLineValid, isLineDefaultsComplete else { return }
        let normalized = normalizedLineDraft(lineDraft)
        _ = store.upsertColorLine(from: normalized, existing: selectedLine)
    }

    private func normalizedLineDraft(_ draft: ColorLineDraft) -> ColorLineDraft {
        var normalized = draft
        normalized.brand = trimmed(draft.brand)
        normalized.name = trimmed(draft.name)
        return normalized
    }

    private func syncDeveloperRatioParts(from ratio: Double?) {
        guard !store.productTypeStore.isDeveloperType(lineDraft.productTypeId) else {
            developerRatioDeveloperPart = nil
            developerRatioColorPart = nil
            return
        }
        developerRatioDeveloperPart = ratio
        developerRatioColorPart = ratio == nil ? nil : 1
    }

    private func updateDeveloperRatioFromParts() {
        guard !store.productTypeStore.isDeveloperType(lineDraft.productTypeId) else {
            lineDraft.defaultDeveloperRatio = nil
            return
        }
        guard let developerPart = developerRatioDeveloperPart,
              let colorPart = developerRatioColorPart,
              colorPart > 0 else {
            lineDraft.defaultDeveloperRatio = nil
            return
        }
        lineDraft.defaultDeveloperRatio = developerPart / colorPart
    }

    private func filteredSuggestions(from options: [String], query: String) -> [String] {
        let trimmedQuery = trimmed(query)
        guard !trimmedQuery.isEmpty else { return options }
        return options.filter { $0.localizedStandardContains(trimmedQuery) }
    }

    private func trimmed(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
