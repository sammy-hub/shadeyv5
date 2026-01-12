import Foundation

enum SubscriptionPlan: String, CaseIterable, Identifiable {
    case monthly
    case yearly

    static let onboardingOrder: [SubscriptionPlan] = [.yearly, .monthly]

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .monthly:
            return "Monthly"
        case .yearly:
            return "Yearly"
        }
    }

    var price: Double {
        switch self {
        case .monthly:
            return 9.99
        case .yearly:
            return 74.99
        }
    }

    var billingDetail: String {
        switch self {
        case .monthly:
            return "Billed monthly"
        case .yearly:
            return "Billed yearly"
        }
    }

    var highlight: String? {
        switch self {
        case .monthly:
            return nil
        case .yearly:
            return "Best value"
        }
    }
}
