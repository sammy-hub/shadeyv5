import Foundation

struct FormulaSelection: Identifiable {
    let id: UUID
    let product: Product
    var amountUsed: Double?
    var ratioPart: Double
    var deductionMode: InventoryDeductionMode

    init(
        product: Product,
        amountUsed: Double? = nil,
        ratioPart: Double = 1,
        deductionMode: InventoryDeductionMode = .openStock
    ) {
        id = product.id
        self.product = product
        self.amountUsed = amountUsed
        self.ratioPart = ratioPart
        self.deductionMode = deductionMode
    }

    var amountValue: Double {
        amountUsed ?? 0
    }

    var cost: Double {
        amountValue * product.costPerUnit
    }
}
