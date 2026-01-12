import OnboardingUI
import SwiftUI

struct OnboardingIntroView: View {
    let onContinue: () -> Void

    var body: some View {
        OnboardingSheetView {
            Text("Welcome to\nShadey")
                .onboardingTextFormatting(style: .title)
        } content: {
            OnboardingItem(systemName: "tray.full", shape: DesignSystem.accent) {
                Text("Inventory that stays ahead")
                    .onboardingTextFormatting(style: .subtitle)
                Text("Log every product, get low-stock alerts, and see exactly what to reorder before you run out.")
                    .onboardingTextFormatting(style: .content)
            }

            OnboardingItem(systemName: "wand.and.stars", shape: DesignSystem.positive) {
                Text("Formulas that never get lost")
                    .onboardingTextFormatting(style: .subtitle)
                Text("Capture mixes, services, and results so every client leaves with the same perfect shade.")
                    .onboardingTextFormatting(style: .content)
            }

            OnboardingItem(systemName: "person.2", shape: DesignSystem.stroke) {
                Text("Client moments, saved")
                    .onboardingTextFormatting(style: .subtitle)
                Text("Keep notes, photos, and service history ready for every appointment.")
                    .onboardingTextFormatting(style: .content)
            }
        } button: {
            ContinueButton(color: DesignSystem.accent, action: onContinue)
        }
    }
}
