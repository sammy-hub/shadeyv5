import Foundation
import Observation

@MainActor
@Observable
final class OnboardingStore {
    private enum Keys {
        static let completed = "onboarding.completed"
        static let signedIn = "onboarding.signedIn"
        static let accessStatus = "onboarding.accessStatus"
        static let activePlan = "onboarding.activePlan"
    }

    private let defaults: UserDefaults
    nonisolated(unsafe) let authService: AuthService

    var hasCompletedOnboarding: Bool {
        didSet {
            defaults.set(hasCompletedOnboarding, forKey: Keys.completed)
        }
    }

    var hasSignedIn: Bool {
        didSet {
            defaults.set(hasSignedIn, forKey: Keys.signedIn)
        }
    }

    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""

    private var accessStatusRaw: String {
        didSet {
            defaults.set(accessStatusRaw, forKey: Keys.accessStatus)
        }
    }

    private var activePlanRaw: String {
        didSet {
            defaults.set(activePlanRaw, forKey: Keys.activePlan)
        }
    }

    var accessStatus: SubscriptionAccessStatus {
        get {
            SubscriptionAccessStatus(rawValue: accessStatusRaw) ?? .none
        }
        set {
            accessStatusRaw = newValue.rawValue
        }
    }

    var activePlan: SubscriptionPlan {
        get {
            SubscriptionPlan(rawValue: activePlanRaw) ?? .monthly
        }
        set {
            activePlanRaw = newValue.rawValue
        }
    }

    var canSignIn: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !password.isEmpty
    }

    var canSignUp: Bool {
        let trimmed = email.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmed.isEmpty && !password.isEmpty && password == confirmPassword && password.count >= 6
    }

    var trialDays: Int { 3 }

    init(defaults: UserDefaults = .standard, authService: AuthService = DefaultAuthService()) {
        self.defaults = defaults
        self.authService = authService
        self.hasCompletedOnboarding = defaults.bool(forKey: Keys.completed)
        self.hasSignedIn = defaults.bool(forKey: Keys.signedIn)
        self.accessStatusRaw = defaults.string(forKey: Keys.accessStatus) ?? SubscriptionAccessStatus.none.rawValue
        self.activePlanRaw = defaults.string(forKey: Keys.activePlan) ?? SubscriptionPlan.monthly.rawValue
    }

    func signIn() {
        guard canSignIn else { return }
        hasSignedIn = true
    }
    
    func signInWithApple(identityToken: String, userID: String, nonce: String?) async throws {
        try await authService.signInWithApple(identityToken: identityToken, userID: userID, nonce: nonce)
        hasSignedIn = true
    }

    func signUp() {
        guard canSignUp else { return }
        // In a real app, create the account here. For now, treat as signed in.
        hasSignedIn = true
    }

    func startTrial() {
        accessStatus = .trial
        hasCompletedOnboarding = true
    }

    func subscribe() {
        accessStatus = .subscribed
        hasCompletedOnboarding = true
    }

    func skipPaywall() {
        hasCompletedOnboarding = true
    }
}

