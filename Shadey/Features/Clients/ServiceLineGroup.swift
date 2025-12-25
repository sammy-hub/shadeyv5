import Foundation

struct ServiceLineGroup: Identifiable {
    let id: String
    let name: String
    let line: ColorLine?
    let products: [Product]
    let totalStock: Double
    let inStockCount: Int

    init(id: String, name: String, line: ColorLine?, products: [Product]) {
        self.id = id
        self.name = name
        self.line = line
        let sortedProducts = products.sorted { lhs, rhs in
            lhs.shadeLabel.localizedStandardCompare(rhs.shadeLabel) == .orderedAscending
        }
        self.products = sortedProducts
        totalStock = sortedProducts.reduce(0) { $0 + $1.stockQuantity }
        inStockCount = sortedProducts.filter { $0.stockQuantity > 0 }.count
    }

    var shadeCount: Int {
        products.count
    }
}
