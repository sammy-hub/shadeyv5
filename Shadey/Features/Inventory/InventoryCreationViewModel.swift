import Foundation
import Observation

@MainActor
@Observable
final class InventoryCreationViewModel {
    private let store: InventoryStore
    var lineDraft: ColorLineDraft
    var productTypeQuery: String
    var shadeDraft: ShadeDraft
    var pendingShades: [ShadeDraft]
    var bulkInput: String
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

    init(store: InventoryStore) {
        self.store = store
        let defaultTypeId = ProductType.permanent.rawValue
        let defaultRatio = store.productTypeStore.defaultRatio(for: defaultTypeId)
        let draft = ColorLineDraft(productTypeId: defaultTypeId, defaultDeveloperRatio: defaultRatio)
        lineDraft = draft
        productTypeQuery = store.productTypeStore.displayName(for: draft.productTypeId)
        shadeDraft = ShadeDraft()
        pendingShades = []
        bulkInput = ""
        developerRatioDeveloperPart = draft.defaultDeveloperRatio
        developerRatioColorPart = 1
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

    var defaultDeveloperName: String? {
        guard let developerId = lineDraft.defaultDeveloperId else { return nil }
        return store.product(id: developerId)?.displayName
    }

    var typeSuggestions: [ProductTypeDefinition] {
        let query = trimmed(productTypeQuery)
        if query.isEmpty {
            return store.productTypeStore.allDefinitions
        }
        return store.productTypeStore.allDefinitions.filter { $0.name.localizedStandardContains(query) }
    }

    var shouldOfferCreateBrand: Bool {
        let value = trimmed(lineDraft.brand)
        guard !value.isEmpty else { return false }
        return !availableBrands.contains { $0.localizedStandardCompare(value) == .orderedSame }
    }

    var shouldOfferCreateLine: Bool {
        let value = trimmed(lineDraft.name)
        guard !value.isEmpty else { return false }
        return !lineSuggestions.contains { $0.localizedStandardCompare(value) == .orderedSame }
    }

    var isLineValid: Bool {
        !trimmed(lineDraft.brand).isEmpty && !trimmed(lineDraft.name).isEmpty
    }

    var isBrandValid: Bool {
        !trimmed(lineDraft.brand).isEmpty
    }

    var isLineNameValid: Bool {
        !trimmed(lineDraft.name).isEmpty
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
            return "Add quantity per unit to calculate cost per unit."
        }
        if let quantity = lineDraft.quantityPerUnit, quantity <= 0 {
            return "Quantity per unit must be greater than 0."
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

    var isShadeValid: Bool {
        let code = trimmed(shadeDraft.shadeCode)
        let name = trimmed(shadeDraft.shadeName)
        return !code.isEmpty || !name.isEmpty
    }

    var canAddShade: Bool {
        isLineValid && isLineDefaultsComplete && isShadeValid
    }

    var canSave: Bool {
        isLineValid && isLineDefaultsComplete && (!pendingShades.isEmpty || isShadeValid)
    }

    var canAddBulk: Bool {
        isLineValid && isLineDefaultsComplete && !trimmed(bulkInput).isEmpty
    }

    func selectBrand(_ brand: String) {
        updateBrand(brand)
    }

    func updateBrand(_ brand: String) {
        let normalized = trimmed(brand)
        let previous = trimmed(lineDraft.brand)
        if previous.localizedStandardCompare(normalized) != .orderedSame {
            lineDraft.name = ""
            lineDraft.defaultDeveloperId = nil
            clearSelectedLine()
        }
        lineDraft.brand = brand
    }

    func selectLineName(_ name: String) {
        let previous = trimmed(lineDraft.name)
        let normalized = trimmed(name)
        lineDraft.name = normalized
        if previous.localizedStandardCompare(normalized) != .orderedSame {
            clearSelectedLine()
        }
        if let line = store.colorLine(brand: trimmed(lineDraft.brand), name: normalized) {
            apply(line: line)
        }
    }

    func updateLineName(_ name: String) {
        let previous = trimmed(lineDraft.name)
        lineDraft.name = name
        if previous.localizedStandardCompare(trimmed(name)) != .orderedSame {
            clearSelectedLine()
        }
        if let line = store.colorLine(brand: trimmed(lineDraft.brand), name: trimmed(name)) {
            apply(line: line)
        }
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

    func addShade() {
        guard canAddShade else { return }
        pendingShades.append(normalizedShadeDraft(from: shadeDraft))
        shadeDraft = ShadeDraft()
    }

    func addBulkShades() {
        let parsed = ShadeBulkParser.parse(bulkInput)
        guard !parsed.isEmpty else { return }
        pendingShades.append(contentsOf: parsed.map { normalizedShadeDraft(from: $0) })
        bulkInput = ""
    }

    func duplicateShade(_ shade: ShadeDraft) {
        shadeDraft = ShadeDraft(
            shadeCode: shade.shadeCode,
            shadeName: shade.shadeName,
            notes: shade.notes,
            stockQuantity: shade.stockQuantity
        )
    }

    func removeShade(_ shade: ShadeDraft) {
        pendingShades.removeAll { $0.id == shade.id }
    }

    func saveAll() {
        guard isLineValid, isLineDefaultsComplete else { return }
        if isShadeValid {
            pendingShades.append(normalizedShadeDraft(from: shadeDraft))
            shadeDraft = ShadeDraft()
        }
        guard !pendingShades.isEmpty else { return }

        let normalizedDraft = normalizedLineDraft(lineDraft)
        let line = store.upsertColorLine(from: normalizedDraft, existing: selectedLine)
        store.addShades(pendingShades, to: line)
        pendingShades = []
        selectedLine = line
    }

    private func apply(line: ColorLine) {
        selectedLine = line
        lineDraft = ColorLineDraft(colorLine: line)
        productTypeQuery = store.productTypeStore.displayName(for: lineDraft.productTypeId)
        pendingShades = []
        shadeDraft = ShadeDraft()
        syncDeveloperRatioParts(from: lineDraft.defaultDeveloperRatio)
    }

    private func clearSelectedLine() {
        selectedLine = nil
        pendingShades = []
        shadeDraft = ShadeDraft()
        syncDeveloperRatioParts(from: lineDraft.defaultDeveloperRatio)
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

    private func normalizedShadeDraft(from draft: ShadeDraft) -> ShadeDraft {
        ShadeDraft(
            shadeCode: trimmed(draft.shadeCode),
            shadeName: trimmed(draft.shadeName),
            notes: trimmed(draft.notes),
            stockQuantity: draft.stockQuantity
        )
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
