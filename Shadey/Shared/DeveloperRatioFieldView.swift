import SwiftUI

struct DeveloperRatioFieldView: View {
    let title: String
    @Binding var developerPart: Double?
    @Binding var colorPart: Double?
    let helperText: String?

    init(
        title: String,
        developerPart: Binding<Double?>,
        colorPart: Binding<Double?>,
        helperText: String? = nil
    ) {
        self.title = title
        self._developerPart = developerPart
        self._colorPart = colorPart
        self.helperText = helperText
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
            Text(title)
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(DesignSystem.textSecondary)

            HStack(alignment: .center, spacing: DesignSystem.Spacing.small) {
                FieldContainerView {
                    OptionalNumberField("Developer", value: $developerPart, format: .number)
                }

                Text(":")
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(DesignSystem.textSecondary)

                FieldContainerView {
                    OptionalNumberField("Color", value: $colorPart, format: .number)
                }
            }

            if let helperText {
                Text(helperText)
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
        }
    }
}
