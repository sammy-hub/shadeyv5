import SwiftUI

struct RecentServiceRowView: View {
    let service: Service

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                Text(service.client?.name ?? "Client")
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Text(service.date, style: .date)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
            Spacer()
            Text(service.totalCost, format: CurrencyFormat.inventory)
                .font(DesignSystem.Typography.headline)
                .foregroundStyle(DesignSystem.textPrimary)
        }
        .padding(.vertical, DesignSystem.Spacing.xSmall)
    }
}
