import SwiftUI

struct OnboardingFlowView: View {
    @State private var viewModel: OnboardingFlowViewModel

    init(viewModel: OnboardingFlowViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        return NavigationStack {
            ZStack {
                OnboardingBackgroundView()

                switch viewModel.step {
                case .intro:
                    OnboardingIntroView {
                        viewModel.goToLogin()
                    }
                case .login:
                    SignInSignUpView(store: viewModel.store) {
                        viewModel.signInAndAdvance()
                    } onSignUp: {
                        viewModel.signUpAndAdvance()
                    } onSkip: {
                        viewModel.goToPaywall()
                    }
                case .paywall:
                    OnboardingPaywallView(store: viewModel.store)
                }
            }
        }
    }
}
