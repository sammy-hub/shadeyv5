import SwiftUI

struct OnboardingPaywallView: View {
    @Bindable var store: OnboardingStore

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xLarge) {
            Spacer()

            Text("Unlock Shadey Pro")
                .font(.title2)
                .bold()
                .foregroundStyle(DesignSystem.textPrimary)

            Text("Start your \(store.trialDays)-day free trial, then choose the plan that fits your salon.")
                .font(.body)
                .foregroundStyle(DesignSystem.textSecondary)

            VStack(spacing: DesignSystem.Spacing.medium) {
                ForEach(SubscriptionPlan.onboardingOrder) { plan in
                    OnboardingPlanCardView(plan: plan, isSelected: store.activePlan == plan) {
                        store.activePlan = plan
                    }
                }
            }

            VStack(spacing: DesignSystem.Spacing.small) {
                Button("Start \(store.trialDays)-day free trial", systemImage: "sparkles") {
                    store.startTrial()
                }
                .buttonStyle(.borderedProminent)

                Button("Continue without trial", systemImage: "chevron.forward") {
                    store.skipPaywall()
                }
                .buttonStyle(.bordered)
            }

            Spacer()
        }
        .padding(DesignSystem.Spacing.pagePadding)
    }
}
