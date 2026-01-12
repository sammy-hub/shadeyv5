import Foundation
import Observation

@MainActor
@Observable
final class StockAlertSettingsStore {
    private static let typeThresholdKey = "stockAlertTypeThresholds"
    private static let brandThresholdKey = "stockAlertBrandThresholds"
    private let defaults: UserDefaults

    var typeThresholds: [String: Double] {
        didSet { save(typeThresholds, key: Self.typeThresholdKey) }
    }

    var brandThresholds: [String: Double] {
        didSet { save(brandThresholds, key: Self.brandThresholdKey) }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        typeThresholds = Self.load(forKey: Self.typeThresholdKey, defaults: defaults)
        brandThresholds = Self.load(forKey: Self.brandThresholdKey, defaults: defaults)
    }

    enum ThresholdSource: String {
        case productOverride
        case brandDefault
        case typeDefault
        case none

        var displayName: String {
            switch self {
            case .productOverride:
                return "Product"
            case .brandDefault:
                return "Brand default"
            case .typeDefault:
                return "Type default"
            case .none:
                return "None"
            }
        }
    }

    struct ThresholdDetails: Equatable {
        let value: Double
        let source: ThresholdSource
    }

    func thresholdDetails(for product: Product) -> ThresholdDetails {
        if product.lowStockThreshold > 0 {
            return ThresholdDetails(value: product.lowStockThreshold, source: .productOverride)
        }

        if let brandValue = brandThresholds[product.resolvedBrand], brandValue > 0 {
            return ThresholdDetails(value: brandValue, source: .brandDefault)
        }

        if let typeValue = typeThresholds[product.resolvedProductTypeId], typeValue > 0 {
            return ThresholdDetails(value: typeValue, source: .typeDefault)
        }

        return ThresholdDetails(value: 0, source: .none)
    }

    func threshold(for product: Product) -> Double {
        thresholdDetails(for: product).value
    }

    func stockStatus(for product: Product) -> StockStatus {
        let lowThreshold = threshold(for: product)
        if lowThreshold > 0, product.stockQuantity <= lowThreshold {
            return .low
        }
        if lowThreshold == 0, product.stockQuantity == 0 {
            return .low
        }
        if product.overstockThreshold > 0, product.stockQuantity >= product.overstockThreshold {
            return .overstock
        }
        return .normal
    }

    private func save(_ value: [String: Double], key: String) {
        let data = try? JSONEncoder().encode(value)
        defaults.set(data, forKey: key)
    }

    private static func load(forKey key: String, defaults: UserDefaults) -> [String: Double] {
        guard let data = defaults.data(forKey: key) else { return [:] }
        return (try? JSONDecoder().decode([String: Double].self, from: data)) ?? [:]
    }
}
