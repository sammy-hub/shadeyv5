import Foundation

enum OnboardingStep: Int, CaseIterable, Identifiable {
    case intro
    case login
    case paywall

    var id: Int { rawValue }
}
