import Foundation

struct ServiceFormulaDraft: Identifiable {
    let id: UUID
    var name: String
    var selections: [FormulaSelection]
    var developer: Product?
    var developerRatio: Double
    var isDeveloperRatioOverridden: Bool
    var usesDefaultDeveloper: Bool
    var recommendedDeveloperStrength: DeveloperStrength?

    init(
        id: UUID = UUID(),
        name: String,
        selections: [FormulaSelection] = [],
        developer: Product? = nil,
        developerRatio: Double = 0,
        isDeveloperRatioOverridden: Bool = false,
        usesDefaultDeveloper: Bool = true,
        recommendedDeveloperStrength: DeveloperStrength? = nil
    ) {
        self.id = id
        self.name = name
        self.selections = selections
        self.developer = developer
        self.developerRatio = developerRatio
        self.isDeveloperRatioOverridden = isDeveloperRatioOverridden
        self.usesDefaultDeveloper = usesDefaultDeveloper
        self.recommendedDeveloperStrength = recommendedDeveloperStrength
    }
}
