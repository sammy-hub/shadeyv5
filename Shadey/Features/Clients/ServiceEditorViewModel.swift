import Foundation
import Observation

@MainActor
@Observable
final class ServiceEditorViewModel {
    private let inventoryStore: InventoryStore
    private let preferencesStore: FormulaBuilderPreferencesStore
    private let defaults: UserDefaults
    var draft: ServiceDraft
    var hideOutOfStock: Bool = false
    var showsStockInSelection: Bool = true
    private var formulaSearchText: [UUID: String] = [:]

    init(
        inventoryStore: InventoryStore,
        preferencesStore: FormulaBuilderPreferencesStore,
        date: Date = .now,
        defaults: UserDefaults = .standard
    ) {
        self.inventoryStore = inventoryStore
        self.preferencesStore = preferencesStore
        self.defaults = defaults
        self.draft = ServiceDraft(date: date)
        for formula in draft.formulas {
            formulaSearchText[formula.id] = ""
        }
    }

    var availableColorProducts: [Product] {
        var products = inventoryStore.products.filter {
            !inventoryStore.productTypeStore.isDeveloperType($0.resolvedProductTypeId)
        }
        if hideOutOfStock {
            products = products.filter { $0.stockQuantity > 0 }
        }
        return products
    }

    var favoriteProducts: [Product] {
        preferencesStore.favoriteProductIds.compactMap { inventoryStore.product(id: $0) }
    }

    var recentProducts: [Product] {
        preferencesStore.recentProductIds.compactMap { inventoryStore.product(id: $0) }
    }

    var availableDeveloperProducts: [Product] {
        inventoryStore.products.filter { $0.resolvedProductTypeId == ProductType.developer.rawValue }
    }

    var totalServiceCost: Double {
        draft.formulas.reduce(0) { $0 + totalCost(for: $1) }
    }

    var totalServiceColorAmount: Double {
        draft.formulas.reduce(0) { $0 + displayColorAmount(for: $1) }
    }

    var totalServiceDeveloperAmount: Double {
        draft.formulas.reduce(0) { $0 + displayDeveloperAmount(for: $1) }
    }

    var totalServiceMixAmount: Double {
        totalServiceColorAmount + totalServiceDeveloperAmount
    }

    var hasMixedUnits: Bool {
        serviceUnits.count > 1
    }

    var deductionLines: [FormulaDeductionLine] {
        draft.formulas.flatMap { FormulaDeductionCalculator.deductionLines(for: $0.selections) }
    }

    var totalDeduction: Double {
        draft.formulas.reduce(0) { $0 + FormulaDeductionCalculator.totalDeduction(for: $1.selections) }
    }

    func searchText(for formulaId: UUID) -> String {
        formulaSearchText[formulaId] ?? ""
    }

    func updateSearchText(_ text: String, for formulaId: UUID) {
        formulaSearchText[formulaId] = text
    }

    func filteredColorProducts(for formulaId: UUID) -> [Product] {
        let query = searchText(for: formulaId).trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return [] }
        return availableColorProducts.filter { product in
            product.displayName.localizedStandardContains(query)
                || product.resolvedBrand.localizedStandardContains(query)
                || product.shadeLabel.localizedStandardContains(query)
                || inventoryStore.productTypeStore.displayName(for: product.resolvedProductTypeId)
                    .localizedStandardContains(query)
                || (product.colorLine?.name.localizedStandardContains(query) ?? false)
        }
        .sorted { $0.displayName.localizedStandardCompare($1.displayName) == .orderedAscending }
    }

    func groupedColorProducts(for formulaId: UUID) -> [ServiceBrandGroup] {
        let products = availableColorProducts
        let groupedByBrand = Dictionary(grouping: products, by: { $0.resolvedBrand })
        let brandGroups = groupedByBrand.map { brand, items in
            let lineGroups = Dictionary(grouping: items) { product in
                product.colorLine?.id.uuidString ?? "ungrouped-\(brand)"
            }
            let lines: [ServiceLineGroup] = lineGroups.map { key, lineProducts in
                let line = lineProducts.compactMap(\.colorLine).first
                let name = line?.name ?? "Unassigned"
                let id = line?.id.uuidString ?? key
                return ServiceLineGroup(id: id, name: name, line: line, products: lineProducts)
            }
            .sorted { (lhs: ServiceLineGroup, rhs: ServiceLineGroup) in
                lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
            }
            return ServiceBrandGroup(id: brand, brand: brand, lines: lines)
        }
        return brandGroups.sorted { (lhs: ServiceBrandGroup, rhs: ServiceBrandGroup) in
            lhs.brand.localizedStandardCompare(rhs.brand) == .orderedAscending
        }
    }

    func typeName(for product: Product) -> String {
        inventoryStore.productTypeStore.displayName(for: product.resolvedProductTypeId)
    }

    func developerLabel(for product: Product?) -> String? {
        guard let product else { return nil }
        if let strength = DeveloperStrength(rawValue: product.developerStrength) {
            return "\(product.displayName) (\(strength.displayName))"
        }
        return product.displayName
    }

    func toggleFavorite(for product: Product) {
        preferencesStore.toggleFavorite(product.id)
    }

    func isFavorite(_ product: Product) -> Bool {
        preferencesStore.favoriteProductIds.contains(product.id)
    }

    func formulaIndex(for formulaId: UUID) -> Int? {
        draft.formulas.firstIndex { $0.id == formulaId }
    }

    func formula(for formulaId: UUID) -> ServiceFormulaDraft? {
        draft.formulas.first { $0.id == formulaId }
    }

    func totalMixAmount(for formula: ServiceFormulaDraft) -> Double {
        displayColorAmount(for: formula) + displayDeveloperAmount(for: formula)
    }

    func updateFormulaName(_ name: String, for formulaId: UUID) {
        guard let index = formulaIndex(for: formulaId) else { return }
        draft.formulas[index].name = name
    }

    func addFormula() {
        let nextIndex = draft.formulas.count + 1
        let newFormula = ServiceFormulaDraft(name: "Formula \(nextIndex)")
        draft.formulas.append(newFormula)
        formulaSearchText[newFormula.id] = ""
    }

    func removeFormula(_ formulaId: UUID) {
        guard draft.formulas.count > 1 else { return }
        draft.formulas.removeAll { $0.id == formulaId }
        formulaSearchText[formulaId] = nil
    }

    func addSelection(for product: Product, formulaId: UUID) {
        guard let index = formulaIndex(for: formulaId) else { return }
        guard !draft.formulas[index].selections.contains(where: { $0.product.id == product.id }) else { return }
        let selection = FormulaSelection(product: product, amountUsed: nil, ratioPart: 1)
        draft.formulas[index].selections.append(selection)
        preferencesStore.recordRecent(product.id)
        updateSearchText("", for: formulaId)
        applySuggestedDeveloperIfNeeded(for: formulaId)
    }

    func toggleSelection(for product: Product, formulaId: UUID) {
        guard let index = formulaIndex(for: formulaId) else { return }
        if let selectionIndex = draft.formulas[index].selections.firstIndex(where: { $0.product.id == product.id }) {
            draft.formulas[index].selections.remove(at: selectionIndex)
            if draft.formulas[index].selections.isEmpty {
                if !draft.formulas[index].isDeveloperRatioOverridden {
                    draft.formulas[index].developerRatio = 0
                }
                if draft.formulas[index].usesDefaultDeveloper {
                    draft.formulas[index].developer = nil
                }
            } else {
                applySuggestedDeveloperIfNeeded(for: formulaId)
            }
            return
        }

        addSelection(for: product, formulaId: formulaId)
    }

    func updateAmount(for selection: FormulaSelection, amount: Double?, formulaId: UUID) {
        guard let index = formulaIndex(for: formulaId),
              let selectionIndex = draft.formulas[index].selections.firstIndex(where: { $0.id == selection.id }) else { return }
        draft.formulas[index].selections[selectionIndex].amountUsed = amount.map { max($0, 0) }
    }

    func updateRatioPart(for selection: FormulaSelection, ratioPart: Double, formulaId: UUID) {
        guard let index = formulaIndex(for: formulaId),
              let selectionIndex = draft.formulas[index].selections.firstIndex(where: { $0.id == selection.id }) else { return }
        draft.formulas[index].selections[selectionIndex].ratioPart = max(ratioPart, 0)
    }

    func updateDeductionMode(for selection: FormulaSelection, mode: InventoryDeductionMode, formulaId: UUID) {
        guard let index = formulaIndex(for: formulaId),
              let selectionIndex = draft.formulas[index].selections.firstIndex(where: { $0.id == selection.id }) else { return }
        draft.formulas[index].selections[selectionIndex].deductionMode = mode
    }

    func adjustAmount(for selection: FormulaSelection, delta: Double, formulaId: UUID) {
        guard let index = formulaIndex(for: formulaId),
              let selectionIndex = draft.formulas[index].selections.firstIndex(where: { $0.id == selection.id }) else { return }
        let current = draft.formulas[index].selections[selectionIndex].amountUsed ?? 0
        draft.formulas[index].selections[selectionIndex].amountUsed = max(current + delta, 0)
    }

    func updateDeveloperSelection(_ developerId: UUID?, formulaId: UUID) {
        guard let index = formulaIndex(for: formulaId) else { return }
        guard let developerId else {
            draft.formulas[index].usesDefaultDeveloper = true
            draft.formulas[index].developer = defaultDeveloper(for: draft.formulas[index])
            return
        }
        draft.formulas[index].usesDefaultDeveloper = false
        draft.formulas[index].developer = inventoryStore.product(id: developerId)
    }

    func updateDeveloperRatio(_ ratio: Double, formulaId: UUID) {
        guard let index = formulaIndex(for: formulaId) else { return }
        draft.formulas[index].isDeveloperRatioOverridden = true
        draft.formulas[index].developerRatio = ratio
    }

    func setDeveloperRatioOverride(_ isOverriding: Bool, formulaId: UUID) {
        guard let index = formulaIndex(for: formulaId) else { return }
        draft.formulas[index].isDeveloperRatioOverridden = isOverriding
        if !isOverriding {
            draft.formulas[index].developerRatio = defaultDeveloperRatio(for: draft.formulas[index])
        } else if draft.formulas[index].developerRatio == 0 {
            draft.formulas[index].developerRatio = defaultDeveloperRatio(for: draft.formulas[index])
        }
    }

    func updateNotes(_ notes: String) {
        draft.notes = notes
    }

    func updateBeforePhotoData(_ data: Data?) {
        draft.beforePhotoData = data
    }

    func updateAfterPhotoData(_ data: Data?) {
        draft.afterPhotoData = data
    }

    func developerAmount(for formula: ServiceFormulaDraft) -> Double {
        ServiceCalculator.developerAmount(for: formula.selections, ratio: activeDeveloperRatio(for: formula))
    }

    func totalCost(for formula: ServiceFormulaDraft) -> Double {
        ServiceCalculator.totalCost(
            selections: formula.selections,
            developer: resolvedDeveloper(for: formula),
            developerAmount: developerAmount(for: formula)
        )
    }

    func totalColorAmount(for formula: ServiceFormulaDraft) -> Double {
        ServiceCalculator.totalColorAmount(for: formula.selections)
    }

    func displayAmount(for selection: FormulaSelection) -> Double? {
        guard let amount = selection.amountUsed else { return nil }
        return selection.product.resolvedUnit.converted(amount, to: preferredUnit)
    }

    func updateDisplayAmount(_ amount: Double?, for selection: FormulaSelection, formulaId: UUID) {
        let converted = amount.map { preferredUnit.converted($0, to: selection.product.resolvedUnit) }
        updateAmount(for: selection, amount: converted, formulaId: formulaId)
    }

    func displayUnitLabel() -> String {
        preferredUnit.displayName
    }

    func displayColorAmount(for formula: ServiceFormulaDraft) -> Double {
        formula.selections.reduce(0) { total, selection in
            total + (displayAmount(for: selection) ?? 0)
        }
    }

    func displayDeveloperAmount(for formula: ServiceFormulaDraft) -> Double {
        displayColorAmount(for: formula) * activeDeveloperRatio(for: formula)
    }

    func totalServiceUnitLabel() -> String {
        preferredUnit.displayName
    }

    func activeDeveloperRatio(for formula: ServiceFormulaDraft) -> Double {
        formula.isDeveloperRatioOverridden ? formula.developerRatio : defaultDeveloperRatio(for: formula)
    }

    func resolvedDeveloper(for formula: ServiceFormulaDraft) -> Product? {
        formula.usesDefaultDeveloper ? defaultDeveloper(for: formula) : formula.developer
    }

    func defaultDeveloperRatio(for formula: ServiceFormulaDraft) -> Double {
        DeveloperSuggestionEngine.suggestion(
            for: formula.selections,
            inventoryStore: inventoryStore,
            productTypeStore: inventoryStore.productTypeStore
        ).ratioSuggestion.ratio
    }

    func defaultDeveloper(for formula: ServiceFormulaDraft) -> Product? {
        DeveloperSuggestionEngine.suggestion(
            for: formula.selections,
            inventoryStore: inventoryStore,
            productTypeStore: inventoryStore.productTypeStore
        ).developer
    }

    func developerSuggestionSource(for formula: ServiceFormulaDraft) -> DeveloperSuggestionSource {
        DeveloperSuggestionEngine.suggestion(
            for: formula.selections,
            inventoryStore: inventoryStore,
            productTypeStore: inventoryStore.productTypeStore
        ).source
    }

    func ratioSuggestionSource(for formula: ServiceFormulaDraft) -> DeveloperRatioSource {
        FormulaDeveloperRuleEngine.suggestedRatio(
            for: formula.selections,
            productTypeStore: inventoryStore.productTypeStore
        ).source
    }

    func activeUnit(for formula: ServiceFormulaDraft) -> UnitType? {
        guard let first = formula.selections.first else { return nil }
        let units = Set(formula.selections.map { $0.product.resolvedUnit })
        guard units.count == 1 else { return nil }
        return first.product.resolvedUnit
    }

    func activeUnitLabel(for formula: ServiceFormulaDraft) -> String {
        preferredUnit.displayName
    }

    func developerUnitLabel(for formula: ServiceFormulaDraft) -> String {
        preferredUnit.displayName
    }

    func amountStep(for formula: ServiceFormulaDraft) -> Double {
        preferredUnit == .grams ? 1 : 0.1
    }

    func isLightenerType(_ formula: ServiceFormulaDraft) -> Bool {
        primaryProductType(for: formula) == .lightener
    }

    func isHairColorType(_ formula: ServiceFormulaDraft) -> Bool {
        guard let type = primaryProductType(for: formula) else { return true }
        return [.permanent, .demiPermanent, .semiPermanent].contains(type)
    }

    func recommendedDeveloperStrength(for formula: ServiceFormulaDraft) -> DeveloperStrength? {
        formula.recommendedDeveloperStrength
    }

    func updateRecommendedDeveloperStrength(_ strength: DeveloperStrength?, formulaId: UUID) {
        guard let index = formulaIndex(for: formulaId) else { return }
        draft.formulas[index].recommendedDeveloperStrength = strength
    }

    func finalizedDraft() -> ServiceDraft {
        var final = draft
        final.formulas = final.formulas.map { formula in
            var updated = formula
            if !updated.isDeveloperRatioOverridden {
                updated.developerRatio = defaultDeveloperRatio(for: updated)
            }
            if updated.usesDefaultDeveloper {
                updated.developer = defaultDeveloper(for: updated)
            }
            return updated
        }
        return final
    }

    private var preferredUnit: UnitType {
        UnitType(rawValue: defaults.string(forKey: SettingsKeys.preferredUnit) ?? UnitType.ounces.rawValue) ?? .ounces
    }

    private var serviceUnits: Set<UnitType> {
        Set(draft.formulas.flatMap { $0.selections.map { $0.product.resolvedUnit } })
    }

    private func primaryProductType(for formula: ServiceFormulaDraft) -> ProductType? {
        guard let rawValue = formula.selections.first?.product.resolvedProductTypeId else { return nil }
        return ProductType(rawValue: rawValue)
    }

    private func applySuggestedDeveloperIfNeeded(for formulaId: UUID) {
        guard let index = formulaIndex(for: formulaId) else { return }
        if !draft.formulas[index].isDeveloperRatioOverridden {
            draft.formulas[index].developerRatio = defaultDeveloperRatio(for: draft.formulas[index])
        }
        if draft.formulas[index].usesDefaultDeveloper {
            draft.formulas[index].developer = defaultDeveloper(for: draft.formulas[index])
        }
    }
}
