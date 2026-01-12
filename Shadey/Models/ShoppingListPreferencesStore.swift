import Foundation
import Observation

@MainActor
@Observable
final class ShoppingListPreferencesStore {
    private static let autoRestockKey = "shoppingAutoRestock"
    private let defaults: UserDefaults

    var autoRestockOnPurchase: Bool {
        didSet {
            defaults.set(autoRestockOnPurchase, forKey: Self.autoRestockKey)
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        autoRestockOnPurchase = defaults.bool(forKey: Self.autoRestockKey)
    }
}
