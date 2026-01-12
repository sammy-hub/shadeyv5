import AuthenticationServices
import CryptoKit
import Security
import SwiftUI

struct AppleSignInButton: View {
    /// Returns identityToken (JWT), Apple user id, and the original nonce
    let onResult: (Result<(identityToken: String, userID: String, nonce: String?), Error>) -> Void

    @State private var nonce: String = AppleSignInButton.randomNonceString()

    var body: some View {
        SignInWithAppleButton(.signIn) { request in
            request.requestedScopes = [.fullName, .email]
            // If your backend expects a hashed nonce (e.g., Firebase style), set it here.
            // Remove this line if your backend doesn't use nonce.
            request.nonce = AppleSignInButton.sha256(nonce)
        } onCompletion: { result in
            switch result {
            case .success(let auth):
                if let credential = auth.credential as? ASAuthorizationAppleIDCredential,
                   let tokenData = credential.identityToken,
                   let token = String(data: tokenData, encoding: .utf8) {
                    onResult(.success((token, credential.user, nonce)))
                } else {
                    onResult(.failure(AuthError.invalidIdentityToken))
                }
            case .failure(let error):
                onResult(.failure(error))
            }
        }
        .signInWithAppleButtonStyle(.black)
        .frame(height: 48)
        .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.medium))
    }
}

extension AppleSignInButton {
    static func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 { return }
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }

    static func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashed = SHA256.hash(data: inputData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
}

