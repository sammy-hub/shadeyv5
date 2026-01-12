import SwiftUI

struct OnboardingPlanCardView: View {
    let plan: SubscriptionPlan
    let isSelected: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            HStack(alignment: .firstTextBaseline, spacing: DesignSystem.Spacing.medium) {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    Text(plan.displayName)
                        .font(.headline)
                        .foregroundStyle(DesignSystem.textPrimary)

                    Text(plan.billingDetail)
                        .font(.caption)
                        .foregroundStyle(DesignSystem.textSecondary)

                    if let highlight = plan.highlight {
                        Text(highlight)
                            .font(.caption)
                            .bold()
                            .foregroundStyle(DesignSystem.accent)
                    }
                }

                Spacer()

                Text(plan.price, format: .currency(code: "USD"))
                    .font(.title3)
                    .bold()
                    .foregroundStyle(DesignSystem.textPrimary)
            }
            .padding(DesignSystem.Spacing.medium)
            .frame(maxWidth: .infinity)
            .background(isSelected ? DesignSystem.accent.opacity(0.12) : DesignSystem.surface.opacity(0.7))
            .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.large))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .stroke(isSelected ? DesignSystem.accent : DesignSystem.stroke, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}
