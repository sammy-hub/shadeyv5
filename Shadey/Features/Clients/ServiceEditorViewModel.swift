import Foundation
import Observation

@MainActor
@Observable
final class ServiceEditorViewModel {
    private let inventoryStore: InventoryStore
    var draft: ServiceDraft
    var selectionMode: ServiceProductSelectionMode = .grouped
    var hideOutOfStock: Bool = false
    var showsStockInSelection: Bool = true
    var isDeveloperRatioOverridden: Bool = false
    var usesDefaultDeveloper: Bool = true

    init(inventoryStore: InventoryStore, date: Date = .now) {
        self.inventoryStore = inventoryStore
        self.draft = ServiceDraft(date: date, developerRatio: 0)
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

    var availableDeveloperProducts: [Product] {
        inventoryStore.products.filter { $0.resolvedProductTypeId == ProductType.developer.rawValue }
    }

    var groupedColorProducts: [ServiceBrandGroup] {
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

    var developerAmount: Double {
        ServiceCalculator.developerAmount(for: draft.selections, ratio: activeDeveloperRatio)
    }

    var totalCost: Double {
        ServiceCalculator.totalCost(
            selections: draft.selections,
            developer: resolvedDeveloper,
            developerAmount: developerAmount
        )
    }

    var defaultDeveloperRatio: Double {
        guard let selection = draft.selections.first else { return 0 }
        let ratio = selection.product.resolvedDefaultDeveloperRatio
        if ratio > 0 {
            return ratio
        }
        return inventoryStore.productTypeStore.defaultRatio(for: selection.product.resolvedProductTypeId)
    }

    var activeDeveloperRatio: Double {
        isDeveloperRatioOverridden ? draft.developerRatio : defaultDeveloperRatio
    }

    var resolvedDeveloper: Product? {
        usesDefaultDeveloper ? defaultDeveloper : draft.developer
    }

    var defaultDeveloper: Product? {
        guard let selection = draft.selections.first else { return nil }
        return inventoryStore.defaultDeveloper(for: selection.product)
    }

    func toggleSelection(for product: Product) {
        if let index = draft.selections.firstIndex(where: { $0.product.id == product.id }) {
            draft.selections.remove(at: index)
            if draft.selections.isEmpty {
                if !isDeveloperRatioOverridden {
                    draft.developerRatio = 0
                }
                if usesDefaultDeveloper {
                    draft.developer = nil
                }
            } else {
                if !isDeveloperRatioOverridden {
                    draft.developerRatio = defaultDeveloperRatio
                }
                if usesDefaultDeveloper {
                    draft.developer = defaultDeveloper
                }
            }
            return
        }

        let ratio = product.resolvedDefaultDeveloperRatio > 0
            ? product.resolvedDefaultDeveloperRatio
            : inventoryStore.productTypeStore.defaultRatio(for: product.resolvedProductTypeId)
        let selection = FormulaSelection(product: product, amountUsed: nil, ratioPart: 1)
        draft.selections.append(selection)
        if !isDeveloperRatioOverridden {
            draft.developerRatio = ratio
        }
        if usesDefaultDeveloper {
            draft.developer = inventoryStore.defaultDeveloper(for: product)
        }
    }

    func updateAmount(for selection: FormulaSelection, amount: Double?) {
        guard let index = draft.selections.firstIndex(where: { $0.id == selection.id }) else { return }
        draft.selections[index].amountUsed = amount.map { max($0, 0) }
    }

    func updateRatioPart(for selection: FormulaSelection, ratioPart: Double) {
        guard let index = draft.selections.firstIndex(where: { $0.id == selection.id }) else { return }
        draft.selections[index].ratioPart = max(ratioPart, 0)
    }

    func updateDeveloperSelection(_ developerId: UUID?) {
        guard let developerId else {
            usesDefaultDeveloper = true
            draft.developer = defaultDeveloper
            return
        }
        usesDefaultDeveloper = false
        draft.developer = inventoryStore.product(id: developerId)
    }

    func updateDeveloperRatio(_ ratio: Double) {
        isDeveloperRatioOverridden = true
        draft.developerRatio = ratio
    }

    func setDeveloperRatioOverride(_ isOverriding: Bool) {
        isDeveloperRatioOverridden = isOverriding
        if !isOverriding {
            draft.developerRatio = defaultDeveloperRatio
        } else if draft.developerRatio == 0 {
            draft.developerRatio = defaultDeveloperRatio
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

    func typeName(for product: Product) -> String {
        inventoryStore.productTypeStore.displayName(for: product.resolvedProductTypeId)
    }

    func finalizedDraft() -> ServiceDraft {
        var final = draft
        if !isDeveloperRatioOverridden {
            final.developerRatio = defaultDeveloperRatio
        }
        if usesDefaultDeveloper {
            final.developer = defaultDeveloper
        }
        return final
    }
}
