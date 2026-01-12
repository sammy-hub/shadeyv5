import CoreData
import Observation

@MainActor
@Observable
final class InventoryStore {
    private let context: NSManagedObjectContext
    private let shoppingListStore: ShoppingListStore
    let productTypeStore: ProductTypeStore
    private(set) var products: [Product] = []
    private(set) var colorLines: [ColorLine] = []
    private var isMigratingColorLines = false
    private static let colorLineMigrationKey = "didMigrateColorLines"

    init(context: NSManagedObjectContext, shoppingListStore: ShoppingListStore, productTypeStore: ProductTypeStore) {
        self.context = context
        self.shoppingListStore = shoppingListStore
        self.productTypeStore = productTypeStore
        reload()
    }

    func reload() {
        guard !isMigratingColorLines else { return }
        let request = Product.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Product.brand, ascending: true)]
        do {
            products = try context.fetch(request)
        } catch {
            products = []
        }

        let lineRequest = ColorLine.fetchRequest()
        lineRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \ColorLine.brand, ascending: true),
            NSSortDescriptor(keyPath: \ColorLine.name, ascending: true)
        ]
        do {
            colorLines = try context.fetch(lineRequest)
        } catch {
            colorLines = []
        }

        if migrateColorLinesIfNeeded() {
            reload()
        }
    }

    func products(
        matching searchText: String,
        sortedBy sortOption: ProductSortOption,
        brandFilter: String?,
        typeFilterId: String?
    ) -> [Product] {
        let filtered = products.filter { product in
            if let brandFilter, product.resolvedBrand != brandFilter {
                return false
            }
            if let typeFilterId, product.resolvedProductTypeId != typeFilterId {
                return false
            }
            guard !searchText.isEmpty else { return true }
            return product.name.localizedStandardContains(searchText)
                || product.resolvedBrand.localizedStandardContains(searchText)
                || productTypeStore.displayName(for: product.resolvedProductTypeId).localizedStandardContains(searchText)
                || (product.shadeCode?.localizedStandardContains(searchText) ?? false)
                || (product.colorLine?.name.localizedStandardContains(searchText) ?? false)
        }

        return filtered.sorted { lhs, rhs in
            switch sortOption {
            case .name:
                if lhs.name == rhs.name {
                    return lhs.resolvedBrand.localizedStandardCompare(rhs.resolvedBrand) == .orderedAscending
                }
                return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
            case .brand:
                if lhs.resolvedBrand == rhs.resolvedBrand {
                    return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
                }
                return lhs.resolvedBrand.localizedStandardCompare(rhs.resolvedBrand) == .orderedAscending
            case .productType:
                if lhs.resolvedProductTypeId == rhs.resolvedProductTypeId {
                    return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
                }
                let lhsType = productTypeStore.displayName(for: lhs.resolvedProductTypeId)
                let rhsType = productTypeStore.displayName(for: rhs.resolvedProductTypeId)
                return lhsType.localizedStandardCompare(rhsType) == .orderedAscending
            case .stockLevel:
                if lhs.stockQuantity == rhs.stockQuantity {
                    return lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
                }
                return lhs.stockQuantity > rhs.stockQuantity
            }
        }
    }

    func addProduct(from draft: ProductDraft) {
        let product = Product(context: context)
        apply(draft: draft, to: product, isNew: true)
        saveContext()
        shoppingListStore.updateAutoList(for: product)
        reload()
    }

    func update(product: Product, with draft: ProductDraft) {
        apply(draft: draft, to: product, isNew: false)
        saveContext()
        shoppingListStore.updateAutoList(for: product)
        reload()
    }

    func colorLine(brand: String, name: String) -> ColorLine? {
        colorLines.first { line in
            line.brand.localizedStandardCompare(brand) == .orderedSame
                && line.name.localizedStandardCompare(name) == .orderedSame
        }
    }

    func colorLines(for brand: String) -> [ColorLine] {
        colorLines.filter { $0.brand.localizedStandardCompare(brand) == .orderedSame }
    }

    func upsertColorLine(from draft: ColorLineDraft, existing: ColorLine? = nil) -> ColorLine {
        let line: ColorLine
        let isNew: Bool
        if let existing {
            line = existing
            isNew = false
        } else if let found = colorLine(brand: draft.brand, name: draft.name) {
            line = found
            isNew = false
        } else {
            line = ColorLine(context: context)
            isNew = true
        }
        if isNew {
            line.id = UUID()
            line.createdAt = .now
        }
        line.brand = draft.brand
        line.name = draft.name
        line.defaultProductTypeRaw = draft.productTypeId
        line.defaultUnit = draft.unit
        line.defaultQuantityPerUnit = draft.quantityPerUnit ?? 0
        line.defaultPurchasePrice = draft.purchasePrice ?? 0
        line.defaultDeveloperRatio = draft.defaultDeveloperRatio ?? 0
        if let developerId = draft.defaultDeveloperId {
            line.defaultDeveloper = product(id: developerId)
        } else {
            line.defaultDeveloper = nil
        }
        line.updatedAt = .now
        saveContext()
        reload()
        return line
    }

    func addShade(from shade: ShadeDraft, to line: ColorLine) {
        let product = Product(context: context)
        product.colorLine = line
        product.id = UUID()
        product.createdAt = .now
        applyLineDefaults(from: line, to: product)
        applyShade(shade, to: product)
        saveContext()
        reload()
    }

    func addShades(_ shades: [ShadeDraft], to line: ColorLine) {
        guard !shades.isEmpty else { return }
        for shade in shades {
            let product = Product(context: context)
            product.colorLine = line
            product.id = UUID()
            product.createdAt = .now
            applyLineDefaults(from: line, to: product)
            applyShade(shade, to: product)
        }
        saveContext()
        reload()
    }

    func adjustStock(for product: Product, by delta: Double) {
        product.stockQuantity = max(product.stockQuantity + delta, 0)
        product.updatedAt = .now
        shoppingListStore.updateAutoList(for: product)
        saveContext()
        reload()
    }

    func delete(product: Product) {
        context.delete(product)
        saveContext()
        reload()
    }

    func product(for barcode: String) -> Product? {
        products.first { $0.barcode == barcode }
    }

    func product(id: UUID) -> Product? {
        products.first { $0.id == id }
    }

    func defaultDeveloper(for colorProduct: Product) -> Product? {
        if let lineDeveloper = colorProduct.colorLine?.defaultDeveloper {
            return lineDeveloper
        }
        let brandMatch = products.filter {
            $0.resolvedProductTypeId == ProductType.developer.rawValue && $0.resolvedBrand == colorProduct.resolvedBrand
        }
        if let preferredStrength = DeveloperStrength(rawValue: colorProduct.recommendedDeveloperStrength),
           let byStrength = brandMatch.first(where: { $0.developerStrength == preferredStrength.rawValue }) {
            return byStrength
        }
        if let anyBrand = brandMatch.first {
            return anyBrand
        }
        return products.first { $0.resolvedProductTypeId == ProductType.developer.rawValue }
    }

    func totalInventoryValue() -> Double {
        products.reduce(0) { $0 + ($1.stockQuantity * $1.costPerUnit) }
    }

    private func apply(draft: ProductDraft, to product: Product, isNew: Bool) {
        if isNew {
            product.id = UUID()
            product.createdAt = .now
        }
        let trimmedShadeCode = draft.shadeCode.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = draft.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        product.name = draft.name
        product.shadeCode = trimmedShadeCode.isEmpty ? nil : trimmedShadeCode
        product.notes = trimmedNotes.isEmpty ? nil : trimmedNotes
        product.stockQuantity = draft.stockQuantity ?? 0
        product.lowStockThreshold = draft.lowStockThreshold ?? 0
        product.overstockThreshold = draft.overstockThreshold ?? 0
        product.barcode = draft.barcode.isEmpty ? nil : draft.barcode
        product.autoAddDisabled = draft.autoAddDisabled
        product.developerStrength = draft.developerStrength?.rawValue ?? 0
        product.recommendedDeveloperStrength = draft.recommendedDeveloperStrength?.rawValue ?? 0
        if let line = product.colorLine {
            applyLineDefaults(from: line, to: product)
            applyOverrides(from: draft, line: line, to: product)
        } else {
            product.brand = draft.brand
            product.productTypeRaw = draft.productTypeId
            product.unit = draft.unit
            product.quantityPerUnit = draft.quantityPerUnit ?? 0
            product.purchasePrice = draft.purchasePrice ?? 0
            product.defaultDeveloperRatio = draft.defaultDeveloperRatio ?? 0
            clearOverrides(for: product)
        }
        product.updatedAt = .now
    }

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }

    private func applyLineDefaults(from line: ColorLine, to product: Product) {
        product.brand = line.brand
        product.productTypeRaw = line.defaultProductTypeRaw
        product.unit = line.defaultUnit
        product.quantityPerUnit = line.defaultQuantityPerUnit
        product.purchasePrice = line.defaultPurchasePrice
        product.defaultDeveloperRatio = line.defaultDeveloperRatio
    }

    private func applyShade(_ shade: ShadeDraft, to product: Product) {
        let trimmedShadeCode = shade.shadeCode.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNotes = shade.notes.trimmingCharacters(in: .whitespacesAndNewlines)
        product.name = shade.shadeName
        product.shadeCode = trimmedShadeCode.isEmpty ? nil : trimmedShadeCode
        product.notes = trimmedNotes.isEmpty ? nil : trimmedNotes
        product.stockQuantity = shade.stockQuantity ?? 0
        product.lowStockThreshold = 0
        product.overstockThreshold = 0
        product.barcode = nil
        product.developerStrength = 0
        product.recommendedDeveloperStrength = 0
        clearOverrides(for: product)
        product.updatedAt = .now
    }

    private func applyOverrides(from draft: ProductDraft, line: ColorLine, to product: Product) {
        let quantityOverride = draft.quantityPerUnit ?? line.defaultQuantityPerUnit
        if quantityOverride != line.defaultQuantityPerUnit {
            product.overrideQuantityPerUnit = NSNumber(value: quantityOverride)
        } else {
            product.overrideQuantityPerUnit = nil
        }

        let purchaseOverride = draft.purchasePrice ?? line.defaultPurchasePrice
        if purchaseOverride != line.defaultPurchasePrice {
            product.overridePurchasePrice = NSNumber(value: purchaseOverride)
        } else {
            product.overridePurchasePrice = nil
        }

        let ratioOverride = draft.defaultDeveloperRatio ?? line.defaultDeveloperRatio
        if ratioOverride != line.defaultDeveloperRatio {
            product.overrideDefaultDeveloperRatio = NSNumber(value: ratioOverride)
        } else {
            product.overrideDefaultDeveloperRatio = nil
        }

        product.overrideUnitRaw = draft.unit != line.defaultUnit ? draft.unit.rawValue : nil
        product.overrideProductTypeRaw = draft.productTypeId != line.defaultProductTypeRaw ? draft.productTypeId : nil
    }

    private func clearOverrides(for product: Product) {
        product.overrideQuantityPerUnit = nil
        product.overridePurchasePrice = nil
        product.overrideDefaultDeveloperRatio = nil
        product.overrideUnitRaw = nil
        product.overrideProductTypeRaw = nil
    }

    private func migrateColorLinesIfNeeded() -> Bool {
        if UserDefaults.standard.bool(forKey: Self.colorLineMigrationKey) {
            return false
        }
        if !colorLines.isEmpty {
            UserDefaults.standard.set(true, forKey: Self.colorLineMigrationKey)
            return false
        }
        guard !products.isEmpty else {
            UserDefaults.standard.set(true, forKey: Self.colorLineMigrationKey)
            return false
        }

        isMigratingColorLines = true
        defer { isMigratingColorLines = false }

        var indexByType: [String: Int] = [:]
        let grouped = Dictionary(grouping: products) { product in
            let key = [
                product.brand,
                product.productTypeRaw,
                product.unitRaw,
                String(product.quantityPerUnit),
                String(product.purchasePrice),
                String(product.defaultDeveloperRatio)
            ].joined(separator: "|")
            return key
        }

        for (_, groupedProducts) in grouped {
            guard let first = groupedProducts.first else { continue }
            let typeKey = "\(first.brand)|\(first.productTypeRaw)"
            let index = (indexByType[typeKey] ?? 0) + 1
            indexByType[typeKey] = index
            let line = ColorLine(context: context)
            line.id = UUID()
            line.createdAt = .now
            line.updatedAt = .now
            line.brand = first.brand
            let typeName = productTypeStore.displayName(for: first.productTypeRaw)
            line.name = "Imported \(typeName) \(index)"
            line.defaultProductTypeRaw = first.productTypeRaw
            line.defaultUnitRaw = first.unitRaw
            line.defaultQuantityPerUnit = first.quantityPerUnit
            line.defaultPurchasePrice = first.purchasePrice
            line.defaultDeveloperRatio = first.defaultDeveloperRatio
            line.defaultDeveloper = defaultDeveloper(for: first)
            for product in groupedProducts {
                product.colorLine = line
            }
        }

        saveContext()
        UserDefaults.standard.set(true, forKey: Self.colorLineMigrationKey)
        return true
    }
}
