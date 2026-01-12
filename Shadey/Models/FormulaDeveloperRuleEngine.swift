import Foundation

enum DeveloperRatioSource: String, CaseIterable, Identifiable, Codable {
    case productOverride
    case productDefault
    case lineDefault
    case productTypeDefault

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .productOverride:
            return "Product override"
        case .productDefault:
            return "Product default"
        case .lineDefault:
            return "Line default"
        case .productTypeDefault:
            return "Product type default"
        }
    }
}

struct DeveloperRatioSuggestion: Equatable {
    let ratio: Double
    let source: DeveloperRatioSource
}

struct FormulaDeveloperRuleEngine {
    @MainActor
    static func suggestedRatio(
        for selections: [FormulaSelection],
        productTypeStore: ProductTypeStore
    ) -> DeveloperRatioSuggestion {
        guard let selection = selections.first else {
            return DeveloperRatioSuggestion(ratio: 0, source: .productTypeDefault)
        }

        let product = selection.product
        if let override = product.overrideDefaultDeveloperRatio?.doubleValue, override > 0 {
            return DeveloperRatioSuggestion(ratio: override, source: .productOverride)
        }

        if let lineRatio = product.colorLine?.defaultDeveloperRatio, lineRatio > 0 {
            return DeveloperRatioSuggestion(ratio: lineRatio, source: .lineDefault)
        }

        if product.defaultDeveloperRatio > 0 {
            return DeveloperRatioSuggestion(ratio: product.defaultDeveloperRatio, source: .productDefault)
        }

        let typeRatio = productTypeStore.defaultRatio(for: product.resolvedProductTypeId)
        return DeveloperRatioSuggestion(ratio: typeRatio, source: .productTypeDefault)
    }
}
