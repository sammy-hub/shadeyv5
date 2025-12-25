import Foundation

struct ShadeBulkParser {
    static func parse(_ input: String) -> [ShadeDraft] {
        let tokens = input
            .split { $0 == "," || $0 == "\n" }
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        return tokens.map { token in
            if let separatorIndex = token.firstIndex(where: { $0 == "-" || $0 == "–" }) {
                let code = token[..<separatorIndex].trimmingCharacters(in: .whitespacesAndNewlines)
                let name = token[token.index(after: separatorIndex)...].trimmingCharacters(in: .whitespacesAndNewlines)
                return ShadeDraft(shadeCode: String(code), shadeName: String(name))
            }
            return ShadeDraft(shadeCode: token, shadeName: "")
        }
    }
}
