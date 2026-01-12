import SwiftUI

struct NumberEntryRow<FormatStyle: ParseableFormatStyle>: View where FormatStyle.FormatInput == Double, FormatStyle.FormatOutput == String {
    let label: String
    let helper: String?
    let unitLabel: String?
    @Binding var value: Double?
    let format: FormatStyle
    let keyboardType: UIKeyboardType

    init(
        _ label: String,
        helper: String? = nil,
        unitLabel: String? = nil,
        value: Binding<Double?>,
        format: FormatStyle,
        keyboardType: UIKeyboardType = .decimalPad
    ) {
        self.label = label
        self.helper = helper
        self.unitLabel = unitLabel
        self._value = value
        self.format = format
        self.keyboardType = keyboardType
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
            HStack {
                Text(label)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Spacer()
                if let unitLabel {
                    Text(unitLabel)
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
            }

            OptionalNumberField(label, value: $value, format: format, keyboardType: keyboardType)
                .textFieldStyle(.roundedBorder)

            if let helper {
                Text(helper)
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
        }
    }
}
