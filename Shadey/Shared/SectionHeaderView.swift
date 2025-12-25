import SwiftUI

struct SectionHeaderView: View {
    let title: String
    let subtitle: String?

    init(title: String, subtitle: String? = nil) {
        self.title = title
        self.subtitle = subtitle
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
            Text(title)
                .font(DesignSystem.Typography.headline)
                .foregroundStyle(DesignSystem.textPrimary)
            if let subtitle {
                Text(subtitle)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
