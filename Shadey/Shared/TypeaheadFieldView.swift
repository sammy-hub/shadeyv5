import SwiftUI

struct TypeaheadFieldView: View {
    let title: String
    @Binding var text: String
    let suggestions: [String]
    let emptyHint: String
    let showCreateOption: Bool
    let showsSuggestionsWhenEmpty: Bool
    let createLabel: String
    let onSelect: (String) -> Void
    let onCreate: (String) -> Void
    let onTextChange: ((String) -> Void)?
    let autocapitalization: TextInputAutocapitalization

    @FocusState private var isFocused: Bool

    init(
        _ title: String,
        text: Binding<String>,
        suggestions: [String],
        emptyHint: String,
        showCreateOption: Bool,
        showsSuggestionsWhenEmpty: Bool = false,
        createLabel: String,
        onSelect: @escaping (String) -> Void,
        onCreate: @escaping (String) -> Void,
        onTextChange: ((String) -> Void)? = nil,
        autocapitalization: TextInputAutocapitalization = .words
    ) {
        self.title = title
        self._text = text
        self.suggestions = suggestions
        self.emptyHint = emptyHint
        self.showCreateOption = showCreateOption
        self.showsSuggestionsWhenEmpty = showsSuggestionsWhenEmpty
        self.createLabel = createLabel
        self.onSelect = onSelect
        self.onCreate = onCreate
        self.onTextChange = onTextChange
        self.autocapitalization = autocapitalization
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            FieldContainerView {
                TextField(title, text: $text)
                    .textInputAutocapitalization(autocapitalization)
                    .autocorrectionDisabled()
                    .focused($isFocused)
                    .onChange(of: text) { _, newValue in
                        onTextChange?(newValue)
                    }
            }

            if isFocused && (showCreateOption || !text.isEmpty || (showsSuggestionsWhenEmpty && !suggestions.isEmpty)) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                    ForEach(suggestions, id: \.self) { suggestion in
                        Button(suggestion) {
                            onSelect(suggestion)
                            isFocused = false
                        }
                        .buttonStyle(.plain)
                        .frame(minHeight: DesignSystem.Layout.minTapHeight, alignment: .leading)
                        .foregroundStyle(DesignSystem.textPrimary)
                    }

                    if showCreateOption {
                        Button("\(createLabel) \"\(text)\"") {
                            onCreate(text)
                            isFocused = false
                        }
                        .buttonStyle(.plain)
                        .frame(minHeight: DesignSystem.Layout.minTapHeight, alignment: .leading)
                        .foregroundStyle(DesignSystem.accent)
                    } else if suggestions.isEmpty && !emptyHint.isEmpty {
                        Text(emptyHint)
                            .font(DesignSystem.Typography.caption)
                            .foregroundStyle(DesignSystem.textSecondary)
                            .frame(minHeight: DesignSystem.Layout.minTapHeight, alignment: .leading)
                    }
                }
                .padding(DesignSystem.Spacing.fieldPadding)
                .background(DesignSystem.secondarySurface)
                .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.medium))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                        .stroke(DesignSystem.stroke, lineWidth: 1)
                )
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}
