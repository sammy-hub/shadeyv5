import SwiftUI

@MainActor
@Observable
final class AppearanceSettings {
    enum ThemePreference: String, CaseIterable, Identifiable {
        case system
        case light
        case dark

        var id: Self { self }

        var displayName: String {
            switch self {
            case .system:
                return "Automatic"
            case .light:
                return "Light"
            case .dark:
                return "Dark"
            }
        }

        var colorScheme: ColorScheme? {
            switch self {
            case .system:
                return nil
            case .light:
                return .light
            case .dark:
                return .dark
            }
        }
    }

    enum AccentSelection: String, CaseIterable, Identifiable {
        case lavender
        case mint
        case coral
        case amber

        var id: Self { self }

        var displayName: String {
            switch self {
            case .lavender:
                return "Lavender"
            case .mint:
                return "Mint"
            case .coral:
                return "Coral"
            case .amber:
                return "Amber"
            }
        }

        var color: Color {
            switch self {
            case .lavender:
                return Color(red: 0.47, green: 0.33, blue: 0.80)
            case .mint:
                return Color(red: 0.29, green: 0.78, blue: 0.66)
            case .coral:
                return Color(red: 0.96, green: 0.52, blue: 0.45)
            case .amber:
                return Color(red: 0.94, green: 0.66, blue: 0.23)
            }
        }
    }

    private let defaults: UserDefaults

    var themePreference: ThemePreference {
        didSet {
            defaults.set(themePreference.rawValue, forKey: SettingsKeys.appearanceTheme)
        }
    }

    var accentSelection: AccentSelection {
        didSet {
            defaults.set(accentSelection.rawValue, forKey: SettingsKeys.accentColor)
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let themeRaw = defaults.string(forKey: SettingsKeys.appearanceTheme) ?? ThemePreference.system.rawValue
        themePreference = ThemePreference(rawValue: themeRaw) ?? .system
        let accentRaw = defaults.string(forKey: SettingsKeys.accentColor) ?? AccentSelection.lavender.rawValue
        accentSelection = AccentSelection(rawValue: accentRaw) ?? .lavender
    }

    var preferredColorScheme: ColorScheme? {
        themePreference.colorScheme
    }

    var accentColor: Color {
        accentSelection.color
    }
}
