import SwiftUI

private enum AuthMode: Hashable {
    case signIn
    case signUp
}

struct SignInSignUpView: View {
    @Bindable var store: OnboardingStore
    let onSignIn: () -> Void
    let onSignUp: () -> Void
    let onSkip: () -> Void

    @State private var mode: AuthMode = .signIn
    @State private var isLoading = false
    @State private var errorMessage: String?

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
            Spacer()

            Text(mode == .signIn ? "Welcome back" : "Create your account")
                .font(.title2)
                .bold()
                .foregroundStyle(DesignSystem.textPrimary)

            Text(mode == .signIn ? "Sign in to sync your formulas, clients, and inventory across devices." : "Sign up to back up and sync your data across devices.")
                .font(.body)
                .foregroundStyle(DesignSystem.textSecondary)

            Picker("Mode", selection: $mode) {
                Text("Sign In").tag(AuthMode.signIn)
                Text("Sign Up").tag(AuthMode.signUp)
            }
            .pickerStyle(.segmented)

            VStack(spacing: DesignSystem.Spacing.medium) {
                FieldContainerView {
                    TextField("Email", text: $store.email)
                        .textContentType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                }

                FieldContainerView {
                    SecureField("Password", text: $store.password)
                        .textContentType(.newPassword)
                }

                if mode == .signUp {
                    FieldContainerView {
                        SecureField("Confirm Password", text: $store.confirmPassword)
                            .textContentType(.newPassword)
                    }

                    if !store.confirmPassword.isEmpty && store.password != store.confirmPassword {
                        Text("Passwords do not match.")
                            .font(DesignSystem.Typography.caption)
                            .foregroundStyle(DesignSystem.warning)
                    }
                }
            }

            if mode == .signIn {
                Button("Continue", systemImage: "arrow.right") {
                    onSignIn()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!store.canSignIn)
            } else {
                Button("Create Account", systemImage: "person.badge.plus") {
                    onSignUp()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!store.canSignUp)
            }

            Button("Use without an account", systemImage: "chevron.forward") {
                onSkip()
            }
            .buttonStyle(.bordered)

            VStack(spacing: DesignSystem.Spacing.medium) {
                HStack(spacing: DesignSystem.Spacing.small) {
                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(DesignSystem.textSecondary)
                    Text("or")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(DesignSystem.textSecondary)
                }

                if isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                } else {
                    AppleSignInButton { result in
                        switch result {
                        case .success(let payload):
                            Task {
                                await handleAppleSignIn(payload)
                            }
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                        }
                    }
                }

                if let errorMessage {
                    Text(errorMessage)
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.warning)
                }
            }

            Spacer()
        }
        .padding(DesignSystem.Spacing.pagePadding)
    }

    private func handleAppleSignIn(_ payload: (identityToken: String, userID: String, nonce: String?)) async {
        await MainActor.run { isLoading = true; errorMessage = nil }
        do {
            try await store.signInWithApple(identityToken: payload.identityToken, userID: payload.userID, nonce: payload.nonce)
            await MainActor.run { isLoading = false }
            onSignIn()
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
            }
        }
    }
}
