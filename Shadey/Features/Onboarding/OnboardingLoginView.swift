import SwiftUI

struct OnboardingLoginView: View {
    @Bindable var store: OnboardingStore
    let onContinue: () -> Void
    let onSkip: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            Spacer()

            Text("Welcome back")
                .font(.title2)
                .bold()
                .foregroundStyle(DesignSystem.textPrimary)

            Text("Sign in to sync your formulas, clients, and inventory across devices.")
                .font(.body)
                .foregroundStyle(DesignSystem.textSecondary)

            VStack(spacing: DesignSystem.Spacing.medium) {
                FieldContainerView {
                    TextField("Email", text: $store.email)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }

                FieldContainerView {
                    SecureField("Password", text: $store.password)
                        .textContentType(.password)
                }
            }

            Button("Continue", systemImage: "arrow.right") {
                onContinue()
            }
            .buttonStyle(.borderedProminent)
            .disabled(!store.canSignIn)

            Button("Use without an account", systemImage: "chevron.forward") {
                onSkip()
            }
            .buttonStyle(.bordered)

            Spacer()
        }
        .padding(DesignSystem.Spacing.pagePadding)
    }
}
