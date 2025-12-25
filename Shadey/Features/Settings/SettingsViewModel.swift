import Foundation
import Observation

@MainActor
@Observable
final class SettingsViewModel {
    private let defaults: UserDefaults

    var profileName: String {
        didSet { defaults.set(profileName, forKey: SettingsKeys.profileName) }
    }

    var salonName: String {
        didSet { defaults.set(salonName, forKey: SettingsKeys.salonName) }
    }

    var preferredUnitRaw: String {
        didSet { defaults.set(preferredUnitRaw, forKey: SettingsKeys.preferredUnit) }
    }

    var notificationsEnabled: Bool {
        didSet { defaults.set(notificationsEnabled, forKey: SettingsKeys.notificationsEnabled) }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        profileName = defaults.string(forKey: SettingsKeys.profileName) ?? ""
        salonName = defaults.string(forKey: SettingsKeys.salonName) ?? ""
        preferredUnitRaw = defaults.string(forKey: SettingsKeys.preferredUnit) ?? UnitType.ounces.rawValue
        notificationsEnabled = defaults.bool(forKey: SettingsKeys.notificationsEnabled)
    }

    var preferredUnit: UnitType {
        get { UnitType(rawValue: preferredUnitRaw) ?? .ounces }
        set { preferredUnitRaw = newValue.rawValue }
    }
}
