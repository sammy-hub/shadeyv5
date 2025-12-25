import SwiftUI

struct ClientsSummaryCardView: View {
    let totalClients: Int

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Client Roster")
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Text("\(totalClients) active clients")
                    .font(DesignSystem.Typography.title)
                    .bold()
                    .foregroundStyle(DesignSystem.textPrimary)
                Text("Tap a client to view formulas and visit history.")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
        }
    }
}
