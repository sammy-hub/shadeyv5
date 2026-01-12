import SwiftUI

struct OnboardingStepIndicatorView: View {
    let step: OnboardingStep

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.small) {
            ForEach(OnboardingStep.allCases) { onboardingStep in
                Capsule()
                    .fill(onboardingStep == step ? DesignSystem.accent : DesignSystem.stroke)
                    .frame(width: DesignSystem.Spacing.large, height: DesignSystem.Spacing.small)
            }
        }
        .padding(.horizontal, DesignSystem.Spacing.pagePadding)
    }
}
