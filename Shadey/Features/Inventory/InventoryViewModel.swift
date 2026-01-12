import Foundation
import Observation

@MainActor
@Observable
final class InventoryViewModel {
    let store: InventoryStore
    let stockAlertSettingsStore: StockAlertSettingsStore
    var searchText: String = "" {
        didSet {
            scheduleSearchDebounce()
        }
    }
    var debouncedSearchText: String = ""
    var sortOption: ProductSortOption = .brand
    var selectedBrand: String?
    var selectedTypeId: String?
    private var searchTask: Task<Void, Never>?

    init(store: InventoryStore, stockAlertSettingsStore: StockAlertSettingsStore) {
        self.store = store
        self.stockAlertSettingsStore = stockAlertSettingsStore
    }

    var products: [Product] {
        store.products(
            matching: debouncedSearchText,
            sortedBy: sortOption,
            brandFilter: selectedBrand,
            typeFilterId: selectedTypeId
        )
    }

    var totalValue: Double {
        store.totalInventoryValue()
    }

    var totalShadeCount: Int {
        store.products.count
    }

    var lowStockCount: Int {
        store.products.filter { stockStatus(for: $0) == .low }.count
    }

    var overstockCount: Int {
        store.products.filter { stockStatus(for: $0) == .overstock }.count
    }

    var availableBrands: [String] {
        let brands = Set(store.products.map(\.resolvedBrand))
        return brands.sorted { $0.localizedStandardCompare($1) == .orderedAscending }
    }

    var availableTypes: [ProductTypeDefinition] {
        let typeIds = Set(store.products.map(\.resolvedProductTypeId))
        let definitions = typeIds.map { store.productTypeStore.definition(for: $0) }
        return definitions.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }

    var hasActiveFilters: Bool {
        selectedBrand != nil || selectedTypeId != nil
    }

    var lineSections: [InventoryLineSection] {
        let filteredProducts = products(in: .hairColor)
        guard !filteredProducts.isEmpty else { return [] }
        return lineSections(for: .hairColor)
    }

    var categorySummaries: [InventoryCategorySummary] {
        InventoryCategory.allCases.map { category in
            let filteredProducts = products(in: category)
            let lineCount = countLines(in: filteredProducts, category: category)
            let lowStockCount = filteredProducts.filter { stockStatus(for: $0) == .low }.count
            let totalValue = filteredProducts.reduce(0) { $0 + ($1.stockQuantity * $1.costPerUnit) }
            return InventoryCategorySummary(
                category: category,
                productCount: filteredProducts.count,
                lineCount: lineCount,
                lowStockCount: lowStockCount,
                totalValue: totalValue
            )
        }
    }

    func products(in category: InventoryCategory) -> [Product] {
        products.filter { categoryForProduct($0) == category }
    }

    func lineSections(for category: InventoryCategory) -> [InventoryLineSection] {
        let filteredProducts = products(in: category)
        guard !filteredProducts.isEmpty else { return [] }

        let grouped = Dictionary(grouping: filteredProducts) { product in
            if category == .hairColor, let lineId = product.colorLine?.id {
                return "line-\(lineId.uuidString)"
            }
            let name = product.colorLine?.name ?? product.name
            return "\(product.resolvedBrand)|\(name)"
        }

        let sections = grouped.values.compactMap { shades -> InventoryLineSection? in
            guard let first = shades.first else { return nil }
            let line = category == .hairColor ? shades.compactMap(\.colorLine).first : nil
            let brand = line?.brand ?? first.resolvedBrand
            let name = line?.name ?? first.name
            return InventoryLineSection(
                line: line,
                brand: brand,
                name: name.isEmpty ? "Unnamed" : name,
                shades: shades,
                stockStatus: stockStatus(for:),
                lowThreshold: effectiveLowStockThreshold(for:)
            )
        }

        return sections.sorted { lhs, rhs in
            if lhs.brand == rhs.brand {
                return lhs.displayTitle.localizedStandardCompare(rhs.displayTitle) == .orderedAscending
            }
            return lhs.brand.localizedStandardCompare(rhs.brand) == .orderedAscending
        }
    }

    func product(for id: UUID) -> Product? {
        store.product(id: id)
    }

    func stockStatus(for product: Product) -> StockStatus {
        stockAlertSettingsStore.stockStatus(for: product)
    }

    func effectiveLowStockThreshold(for product: Product) -> Double {
        stockAlertSettingsStore.threshold(for: product)
    }

    func thresholdDetails(for product: Product) -> StockAlertSettingsStore.ThresholdDetails {
        stockAlertSettingsStore.thresholdDetails(for: product)
    }

    func refresh() {
        store.reload()
    }

    func toggleBrandFilter(_ brand: String) {
        selectedBrand = selectedBrand == brand ? nil : brand
    }

    func toggleTypeFilter(_ type: ProductTypeDefinition) {
        selectedTypeId = selectedTypeId == type.id ? nil : type.id
    }

    func clearFilters() {
        selectedBrand = nil
        selectedTypeId = nil
    }

    private func scheduleSearchDebounce() {
        searchTask?.cancel()
        let query = searchText
        searchTask = Task { [weak self] in
            try? await Task.sleep(for: .milliseconds(300))
            guard !Task.isCancelled else { return }
            await MainActor.run {
                self?.debouncedSearchText = query
            }
        }
    }

    private func categoryForProduct(_ product: Product) -> InventoryCategory {
        if let type = ProductType(rawValue: product.resolvedProductTypeId) {
            switch type {
            case .developer:
                return .developer
            case .lightener:
                return .lightener
            case .treatment:
                return .treatment
            case .permanent, .demiPermanent, .semiPermanent:
                return .hairColor
            }
        }
        return .hairColor
    }

    private func countLines(in products: [Product], category: InventoryCategory) -> Int {
        let identifiers = Set(products.map { product in
            if category == .hairColor, let lineId = product.colorLine?.id {
                return "line-\(lineId.uuidString)"
            }
            let name = product.colorLine?.name ?? product.name
            return "\(product.resolvedBrand)|\(name)"
        })
        return identifiers.count
    }
}
