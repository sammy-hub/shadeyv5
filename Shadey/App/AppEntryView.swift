import SwiftUI

struct AppEntryView: View {
    let appData: AppData
    @Bindable var onboardingStore: OnboardingStore

    init(appData: AppData) {
        self.appData = appData
        self.onboardingStore = appData.onboardingStore
    }

    var body: some View {
        if onboardingStore.hasCompletedOnboarding {
            RootTabView(appData: appData)
        } else {
            OnboardingFlowView(viewModel: OnboardingFlowViewModel(store: onboardingStore))
        }
    }
}
