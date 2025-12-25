import Foundation

struct ServiceCalculator {
    static func totalColorAmount(for selections: [FormulaSelection]) -> Double {
        selections.reduce(0) { $0 + $1.amountValue }
    }

    static func developerAmount(for selections: [FormulaSelection], ratio: Double) -> Double {
        totalColorAmount(for: selections) * ratio
    }

    static func totalCost(
        selections: [FormulaSelection],
        developer: Product?,
        developerAmount: Double
    ) -> Double {
        let colorCost = selections.reduce(0) { $0 + $1.cost }
        let developerCost = (developer?.costPerUnit ?? 0) * developerAmount
        return colorCost + developerCost
    }
}
