import Foundation

struct FormulaDeductionLine: Identifiable {
    let id: UUID
    let product: Product
    let amount: Double
    let mode: InventoryDeductionMode

    init(id: UUID = UUID(), product: Product, amount: Double, mode: InventoryDeductionMode) {
        self.id = id
        self.product = product
        self.amount = amount
        self.mode = mode
    }
}

struct FormulaDeductionCalculator {
    static func deductionAmount(for selection: FormulaSelection) -> Double {
        let amount = selection.amountValue
        switch selection.deductionMode {
        case .openStock:
            return amount
        case .newUnit:
            let unitQuantity = selection.product.resolvedQuantityPerUnit
            if unitQuantity > 0 {
                return max(amount, unitQuantity)
            }
            return amount
        }
    }

    static func deductionLines(for selections: [FormulaSelection]) -> [FormulaDeductionLine] {
        selections.map { selection in
            FormulaDeductionLine(
                product: selection.product,
                amount: deductionAmount(for: selection),
                mode: selection.deductionMode
            )
        }
    }

    static func totalDeduction(for selections: [FormulaSelection]) -> Double {
        deductionLines(for: selections).reduce(0) { $0 + $1.amount }
    }
}
