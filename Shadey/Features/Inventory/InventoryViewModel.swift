import Foundation
import Observation

@MainActor
@Observable
final class InventoryViewModel {
    let store: InventoryStore
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

    init(store: InventoryStore) {
        self.store = store
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
        store.products.filter { $0.stockStatus == .low }.count
    }

    var overstockCount: Int {
        store.products.filter { $0.stockStatus == .overstock }.count
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
        let filteredProducts = products
        guard !filteredProducts.isEmpty else { return [] }
        let grouped = Dictionary(grouping: filteredProducts) { product in
            if let lineId = product.colorLine?.id {
                return "line-\(lineId.uuidString)"
            }
            return "ungrouped-\(product.resolvedBrand)"
        }

        let sections = grouped.values.compactMap { shades -> InventoryLineSection? in
            guard let first = shades.first else { return nil }
            let line = shades.compactMap(\.colorLine).first
            let brand = line?.brand ?? first.resolvedBrand
            let name = line?.name ?? "Unassigned"
            return InventoryLineSection(line: line, brand: brand, name: name, shades: shades)
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
}
