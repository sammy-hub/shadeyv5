import SwiftUI

struct ClientStatsCardView: View {
    let totalVisits: Int
    let totalSpend: Double

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Client Summary")
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Text(totalSpend, format: CurrencyFormat.inventory)
                    .font(DesignSystem.Typography.title)
                    .bold()
                    .foregroundStyle(DesignSystem.textPrimary)
                Text("\(totalVisits) services on record")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
        }
    }
}
