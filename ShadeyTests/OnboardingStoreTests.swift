import XCTest
@testable import Shadey

final class OnboardingStoreTests: XCTestCase {
    func testSignInUpdatesSignedInState() {
        let defaults = makeDefaults()
        let store = OnboardingStore(defaults: defaults)
        store.email = "artist@studio.com"
        store.password = "password"

        store.signIn()

        XCTAssertTrue(store.hasSignedIn)
    }

    func testStartTrialCompletesOnboarding() {
        let defaults = makeDefaults()
        let store = OnboardingStore(defaults: defaults)

        store.startTrial()

        XCTAssertEqual(store.accessStatus, .trial)
        XCTAssertTrue(store.hasCompletedOnboarding)
    }

    func testActivePlanPersistsAcrossInstances() {
        let defaults = makeDefaults()
        let store = OnboardingStore(defaults: defaults)
        store.activePlan = .yearly

        let reloaded = OnboardingStore(defaults: defaults)

        XCTAssertEqual(reloaded.activePlan, .yearly)
    }

    private func makeDefaults() -> UserDefaults {
        let suiteName = "OnboardingStoreTests.\(UUID().uuidString)"
        guard let defaults = UserDefaults(suiteName: suiteName) else {
            XCTFail("Failed to create UserDefaults suite")
            return .standard
        }
        defaults.removePersistentDomain(forName: suiteName)
        return defaults
    }
}
