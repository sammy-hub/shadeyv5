import SwiftUI

struct RecentServiceRowView: View {
    let service: Service

    var body: some View {
        ListRowView(
            systemImage: "scissors",
            title: service.client?.name ?? "Client",
            subtitle: service.date.formatted(AppFormatters.dateAbbreviated)
        ) {
            Text(service.totalCost.formatted(AppFormatters.currency))
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(DesignSystem.textSecondary)
        }
        .accessibilityElement(children: .combine)
    }
}
