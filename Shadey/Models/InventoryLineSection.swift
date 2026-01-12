import Foundation

struct InventoryLineSection: Identifiable {
    let id: String
    let line: ColorLine?
    let brand: String
    let name: String
    let unit: UnitType
    let shades: [Product]
    let totalStock: Double
    let inStockCount: Int
    let lowStockCount: Int
    let overstockCount: Int
    let fillRatio: Double

    init(
        line: ColorLine?,
        brand: String,
        name: String,
        shades: [Product],
        stockStatus: (Product) -> StockStatus,
        lowThreshold: (Product) -> Double
    ) {
        self.line = line
        self.brand = brand
        self.name = name
        let unit = line?.defaultUnit ?? shades.first?.resolvedUnit ?? .ounces
        self.unit = unit
        let sortedShades = shades.sorted { lhs, rhs in
            lhs.shadeLabel.localizedStandardCompare(rhs.shadeLabel) == .orderedAscending
        }
        self.shades = sortedShades
        let totalStock = sortedShades.reduce(0) { $0 + $1.stockQuantity }
        self.totalStock = totalStock
        let inStockCount = sortedShades.filter { $0.stockQuantity > 0 }.count
        self.inStockCount = inStockCount
        let lowStockCount = sortedShades.filter { stockStatus($0) == .low }.count
        self.lowStockCount = lowStockCount
        let overstockCount = sortedShades.filter { stockStatus($0) == .overstock }.count
        self.overstockCount = overstockCount
        let lowThresholdTotal = sortedShades.reduce(0) { $0 + lowThreshold($1) }
        let ratio: Double
        if lowThresholdTotal > 0 {
            ratio = min(totalStock / lowThresholdTotal, 1)
        } else if sortedShades.isEmpty {
            ratio = 0
        } else {
            ratio = Double(inStockCount) / Double(sortedShades.count)
        }
        self.fillRatio = max(0, min(ratio, 1))
        if let lineId = line?.id {
            id = lineId.uuidString
        } else {
            id = "\(brand)|\(name)".lowercased()
        }
    }

    var shadeCount: Int {
        shades.count
    }

    var displayTitle: String {
        if line == nil {
            return name
        }
        return name
    }

    var displaySubtitle: String {
        brand
    }
}
