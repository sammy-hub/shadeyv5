import Foundation

struct FormulaSelection: Identifiable {
    let id: UUID
    let product: Product
    var amountUsed: Double?
    var ratioPart: Double

    init(product: Product, amountUsed: Double? = nil, ratioPart: Double = 1) {
        id = product.id
        self.product = product
        self.amountUsed = amountUsed
        self.ratioPart = ratioPart
    }

    var amountValue: Double {
        amountUsed ?? 0
    }

    var cost: Double {
        amountValue * product.costPerUnit
    }
}
