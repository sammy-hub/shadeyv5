import Foundation
import Observation

@MainActor
@Observable
final class OnboardingFlowViewModel {
    let store: OnboardingStore
    var step: OnboardingStep = .intro

    init(store: OnboardingStore) {
        self.store = store
    }

    func goToLogin() {
        step = .login
    }

    func goToPaywall() {
        step = .paywall
    }

    func signInAndAdvance() {
        store.signIn()
        if store.hasSignedIn {
            step = .paywall
        }
    }
    
    func signUpAndAdvance() {
        store.signUp()
        if store.hasSignedIn {
            step = .paywall
        }
    }
}
