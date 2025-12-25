import Foundation

enum DeveloperStrength: Int16, CaseIterable, Identifiable {
    case vol10 = 10
    case vol20 = 20
    case vol30 = 30
    case vol40 = 40

    var id: Int16 { rawValue }

    var displayName: String {
        "\(rawValue) vol"
    }
}
