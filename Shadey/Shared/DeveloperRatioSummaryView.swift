import SwiftUI

struct DeveloperRatioSummaryView: View {
    let ratio: Double
    let helperText: String?

    init(ratio: Double, helperText: String? = nil) {
        self.ratio = ratio
        self.helperText = helperText
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
            Text("Developer : Color")
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(DesignSystem.textSecondary)

            Text("\(ratio.formatted(.number)) : 1")
                .font(DesignSystem.Typography.headline)
                .foregroundStyle(DesignSystem.textPrimary)

            if let helperText {
                Text(helperText)
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
        }
    }
}
