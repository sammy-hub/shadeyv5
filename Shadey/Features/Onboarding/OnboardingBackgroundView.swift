import SwiftUI

struct OnboardingBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [DesignSystem.background, DesignSystem.secondarySurface, DesignSystem.surface],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(DesignSystem.accent.opacity(0.28))
                .blur(radius: DesignSystem.CornerRadius.large)
                .offset(x: -DesignSystem.Spacing.xxLarge, y: -DesignSystem.Spacing.large)

            RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                .fill(DesignSystem.surface.opacity(0.4))
                .blur(radius: DesignSystem.CornerRadius.medium)
                .rotationEffect(.degrees(12))
                .offset(x: DesignSystem.Spacing.large, y: DesignSystem.Spacing.xxLarge)
        }
        .ignoresSafeArea()
    }
}
