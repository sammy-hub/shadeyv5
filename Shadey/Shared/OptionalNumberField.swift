import SwiftUI

struct OptionalNumberField<FormatStyle: ParseableFormatStyle>: View where FormatStyle.FormatInput == Double, FormatStyle.FormatOutput == String {
    let title: String
    @Binding var value: Double?
    let format: FormatStyle
    let keyboardType: UIKeyboardType
    let accessibilityLabel: String?

    @FocusState private var isFocused: Bool
    @State private var text: String = ""

    init(
        _ title: String,
        value: Binding<Double?>,
        format: FormatStyle,
        keyboardType: UIKeyboardType = .decimalPad,
        accessibilityLabel: String? = nil
    ) {
        self.title = title
        self._value = value
        self.format = format
        self.keyboardType = keyboardType
        self.accessibilityLabel = accessibilityLabel
    }

    var body: some View {
        TextField(title, text: $text)
            .keyboardType(keyboardType)
            .focused($isFocused)
            .onAppear {
                text = formattedText(for: value)
            }
            .onChange(of: value) { _, newValue in
                guard !isFocused else { return }
                text = formattedText(for: newValue)
            }
            .onChange(of: text) { _, newValue in
                guard isFocused else { return }
                if newValue.isEmpty {
                    value = nil
                    return
                }
                if let parsed = try? format.parseStrategy.parse(newValue) {
                    value = parsed
                }
            }
            .onChange(of: isFocused) { _, newValue in
                guard !newValue else { return }
                text = formattedText(for: value)
            }
            .accessibilityLabel(Text(accessibilityLabel ?? title))
    }

    private func formattedText(for value: Double?) -> String {
        guard let value else { return "" }
        return value.formatted(format)
    }
}
