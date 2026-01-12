import Foundation

enum DeveloperSuggestionSource: String, CaseIterable, Identifiable, Codable {
    case lineDefault
    case strengthMatch
    case brandMatch
    case fallback

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .lineDefault:
            return "Line default"
        case .strengthMatch:
            return "Strength match"
        case .brandMatch:
            return "Brand match"
        case .fallback:
            return "Best available"
        }
    }
}

struct DeveloperSuggestion: Equatable {
    let developer: Product?
    let ratioSuggestion: DeveloperRatioSuggestion
    let source: DeveloperSuggestionSource
}

struct DeveloperSuggestionEngine {
    @MainActor
    static func suggestion(
        for selections: [FormulaSelection],
        inventoryStore: InventoryStore,
        productTypeStore: ProductTypeStore
    ) -> DeveloperSuggestion {
        let ratioSuggestion = FormulaDeveloperRuleEngine.suggestedRatio(
            for: selections,
            productTypeStore: productTypeStore
        )

        guard let selection = selections.first else {
            return DeveloperSuggestion(
                developer: nil,
                ratioSuggestion: ratioSuggestion,
                source: .fallback
            )
        }

        if let lineDeveloper = selection.product.colorLine?.defaultDeveloper {
            return DeveloperSuggestion(
                developer: lineDeveloper,
                ratioSuggestion: ratioSuggestion,
                source: .lineDefault
            )
        }

        if selection.product.recommendedDeveloperStrength > 0,
           let match = inventoryStore.defaultDeveloper(for: selection.product) {
            return DeveloperSuggestion(
                developer: match,
                ratioSuggestion: ratioSuggestion,
                source: .strengthMatch
            )
        }

        if let match = inventoryStore.defaultDeveloper(for: selection.product) {
            return DeveloperSuggestion(
                developer: match,
                ratioSuggestion: ratioSuggestion,
                source: .brandMatch
            )
        }

        return DeveloperSuggestion(
            developer: nil,
            ratioSuggestion: ratioSuggestion,
            source: .fallback
        )
    }
}
