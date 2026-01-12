import Foundation
import Observation

@MainActor
@Observable
final class FormulaBuilderPreferencesStore {
    private static let favoritesKey = "formulaFavorites"
    private static let recentsKey = "formulaRecents"
    private static let recentsLimit = 12
    private let defaults: UserDefaults

    private(set) var favoriteProductIds: [UUID] {
        didSet { saveFavorites() }
    }

    private(set) var recentProductIds: [UUID] {
        didSet { saveRecents() }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        favoriteProductIds = Self.loadIds(forKey: Self.favoritesKey, defaults: defaults)
        recentProductIds = Self.loadIds(forKey: Self.recentsKey, defaults: defaults)
    }

    func toggleFavorite(_ id: UUID) {
        if let index = favoriteProductIds.firstIndex(of: id) {
            favoriteProductIds.remove(at: index)
        } else {
            favoriteProductIds.insert(id, at: 0)
        }
    }

    func recordRecent(_ id: UUID) {
        recentProductIds.removeAll { $0 == id }
        recentProductIds.insert(id, at: 0)
        recentProductIds = Array(recentProductIds.prefix(Self.recentsLimit))
    }

    func clearRecents() {
        recentProductIds = []
    }

    private func saveFavorites() {
        saveIds(favoriteProductIds, forKey: Self.favoritesKey)
    }

    private func saveRecents() {
        saveIds(recentProductIds, forKey: Self.recentsKey)
    }

    private func saveIds(_ ids: [UUID], forKey key: String) {
        let raw = ids.map { $0.uuidString }
        defaults.set(raw, forKey: key)
    }

    private static func loadIds(forKey key: String, defaults: UserDefaults) -> [UUID] {
        let raw = defaults.stringArray(forKey: key) ?? []
        return raw.compactMap { UUID(uuidString: $0) }
    }
}
