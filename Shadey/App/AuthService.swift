import Foundation

enum AuthError: Error, LocalizedError {
    case invalidIdentityToken
    case backendError(status: Int)

    var errorDescription: String? {
        switch self {
        case .invalidIdentityToken:
            return "Invalid identity token returned from Apple."
        case .backendError(let status):
            return "Backend returned an error (status code: \(status))."
        }
    }
}

protocol AuthService {
    /// Exchange Apple identity token with your backend, create a session, and return when authenticated.
    func signInWithApple(identityToken: String, userID: String, nonce: String?) async throws
}

struct DefaultAuthService: AuthService {
    /// Change this to your backend URL, e.g., https://api.yourdomain.com
    let baseURL: URL

    init(baseURL: URL = URL(string: "https://api.example.com")!) {
        self.baseURL = baseURL
    }

    func signInWithApple(identityToken: String, userID: String, nonce: String?) async throws {
        var request = URLRequest(url: baseURL.appendingPathComponent("/auth/apple"))
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let payload: [String: Any?] = [
            "identityToken": identityToken,
            "user": userID,
            "nonce": nonce
        ]
        request.httpBody = try JSONSerialization.data(withJSONObject: payload.compactMapValues { $0 }, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            throw AuthError.backendError(status: -1)
        }
        guard (200..<300).contains(http.statusCode) else {
            #if DEBUG
            if let body = String(data: data, encoding: .utf8) {
                print("Auth backend error: \(http.statusCode) body=\(body)")
            }
            #endif
            throw AuthError.backendError(status: http.statusCode)
        }
        // If needed, parse response and persist session token/refresh token here.
    }
}
