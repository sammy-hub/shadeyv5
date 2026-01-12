import SwiftUI

struct OnboardingFeatureView: View {
    let title: String
    let subtitle: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xLarge) {
            Spacer()

            Image(systemName: systemImage)
                .font(.system(.largeTitle, design: .rounded))
                .foregroundStyle(DesignSystem.accent)
                .padding(DesignSystem.Spacing.small)
                .background(DesignSystem.surface.opacity(0.7))
                .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.medium))

            Text(title)
                .font(.title2)
                .bold()
                .foregroundStyle(DesignSystem.textPrimary)

            Text(subtitle)
                .font(.body)
                .foregroundStyle(DesignSystem.textSecondary)

            Spacer()
        }
        .padding(DesignSystem.Spacing.pagePadding)
    }
}
