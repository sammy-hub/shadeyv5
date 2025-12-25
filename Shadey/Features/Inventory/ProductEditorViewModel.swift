import Foundation
import Observation

@MainActor
@Observable
final class ProductEditorViewModel {
    private static let pinnedBrandsKey = "pinnedBrands"
    private static let pinnedLimit = 6

    private let store: InventoryStore
    let product: Product?
    var draft: ProductDraft
    var productTypeQuery: String
    var pinnedBrands: [String] {
        didSet {
            savePinnedBrands()
        }
    }

    init(
        store: InventoryStore,
        product: Product? = nil,
        prefilledBarcode: String? = nil,
        prefilledBrand: String? = nil,
        prefilledProductTypeId: String? = nil
    ) {
        self.store = store
        self.product = product
        let initialDraft: ProductDraft
        if let product {
            initialDraft = ProductDraft(product: product)
        } else {
            var newDraft = ProductDraft()
            if let prefilledBarcode {
                newDraft.barcode = prefilledBarcode
            }
            if let prefilledBrand {
                newDraft.brand = prefilledBrand
            }
            if let prefilledProductTypeId {
                newDraft.productTypeId = prefilledProductTypeId
            }
            initialDraft = newDraft
        }
        draft = initialDraft
        productTypeQuery = store.productTypeStore.displayName(for: initialDraft.productTypeId)
        pinnedBrands = Self.loadPinnedBrands()
        if product == nil {
            applyDefaultRatioIfNeeded()
        }
    }

    var isEditing: Bool {
        product != nil
    }

    var hasColorLine: Bool {
        product?.colorLine != nil
    }

    var isDeveloperType: Bool {
        store.productTypeStore.isDeveloperType(draft.productTypeId)
    }

    var isSaveEnabled: Bool {
        isBrandValid && isNameValid
    }

    var isBrandValid: Bool {
        !trimmed(draft.brand).isEmpty
    }

    var isNameValid: Bool {
        !trimmed(draft.name).isEmpty || !trimmed(draft.shadeCode).isEmpty
    }

    var costPerUnit: Double? {
        guard let quantity = draft.quantityPerUnit, quantity > 0, let price = draft.purchasePrice else {
            return nil
        }
        return price / quantity
    }

    var pricingHint: String? {
        if draft.quantityPerUnit == nil || draft.purchasePrice == nil {
            return "Add quantity and price to calculate cost per unit."
        }
        if let quantity = draft.quantityPerUnit, quantity <= 0 {
            return "Quantity per unit must be greater than 0."
        }
        if let price = draft.purchasePrice, price < 0 {
            return "Purchase price can’t be negative."
        }
        return nil
    }

    var availableBrands: [String] {
        let brands = Set(store.products.map(\.resolvedBrand))
        return brands.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }

    var availableShades: [String] {
        let products = store.products.filter { product in
            let brand = trimmed(draft.brand)
            guard !brand.isEmpty else { return true }
            return product.resolvedBrand.localizedStandardCompare(brand) == .orderedSame
        }
        let names = Set(products.map(\.name))
        return names.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }

    var recentBrands: [String] {
        let sorted = store.products.sorted { $0.updatedAt > $1.updatedAt }
        var seen = Set<String>()
        var recents: [String] = []
        for product in sorted where !seen.contains(product.resolvedBrand) {
            recents.append(product.resolvedBrand)
            seen.insert(product.resolvedBrand)
        }
        return Array(recents.prefix(6))
    }

    var brandSuggestions: [String] {
        filteredSuggestions(from: availableBrands, query: draft.brand)
    }

    var shadeSuggestions: [String] {
        filteredSuggestions(from: availableShades, query: draft.name)
    }

    var typeSuggestions: [ProductTypeDefinition] {
        let query = trimmed(productTypeQuery)
        if query.isEmpty {
            return store.productTypeStore.allDefinitions
        }
        return store.productTypeStore.allDefinitions.filter { $0.name.localizedStandardContains(query) }
    }

    var shouldOfferCreateBrand: Bool {
        let value = trimmed(draft.brand)
        guard !value.isEmpty else { return false }
        return !availableBrands.contains { $0.localizedStandardCompare(value) == .orderedSame }
    }

    var shouldOfferCreateShade: Bool {
        let value = trimmed(draft.name)
        guard !value.isEmpty else { return false }
        return !availableShades.contains { $0.localizedStandardCompare(value) == .orderedSame }
    }

    var isCurrentBrandPinned: Bool {
        let value = trimmed(draft.brand)
        guard !value.isEmpty else { return false }
        return pinnedBrands.contains { $0.localizedStandardCompare(value) == .orderedSame }
    }

    func selectBrand(_ brand: String) {
        draft.brand = brand
    }

    func selectShade(_ shade: String) {
        draft.name = shade
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
        draft.productTypeId = type.id
        productTypeQuery = type.name
        applyDefaultRatioIfNeeded()
    }

    func applyDefaultRatioIfNeeded() {
        guard !store.productTypeStore.isDeveloperType(draft.productTypeId) else { return }
        if draft.defaultDeveloperRatio == nil || draft.defaultDeveloperRatio == 0 {
            draft.defaultDeveloperRatio = store.productTypeStore.defaultRatio(for: draft.productTypeId)
        }
    }

    func togglePinnedBrand(_ brand: String) {
        let normalized = trimmed(brand)
        guard !normalized.isEmpty else { return }
        if let index = pinnedBrands.firstIndex(where: { $0.localizedStandardCompare(normalized) == .orderedSame }) {
            pinnedBrands.remove(at: index)
        } else {
            pinnedBrands.insert(normalized, at: 0)
            pinnedBrands = Array(pinnedBrands.prefix(Self.pinnedLimit))
        }
    }

    func pinCurrentBrand() {
        togglePinnedBrand(draft.brand)
    }

    func save() {
        if let product {
            store.update(product: product, with: draft)
        } else {
            store.addProduct(from: draft)
        }
    }

    private func filteredSuggestions(from options: [String], query: String) -> [String] {
        let trimmedQuery = trimmed(query)
        guard !trimmedQuery.isEmpty else { return options }
        return options.filter { $0.localizedStandardContains(trimmedQuery) }
    }

    private func trimmed(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func loadPinnedBrands() -> [String] {
        UserDefaults.standard.stringArray(forKey: pinnedBrandsKey) ?? []
    }

    private func savePinnedBrands() {
        UserDefaults.standard.set(pinnedBrands, forKey: Self.pinnedBrandsKey)
    }
}
