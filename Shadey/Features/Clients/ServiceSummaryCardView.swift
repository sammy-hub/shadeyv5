import SwiftUI

struct ServiceSummaryCardView: View {
    let service: Service

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Service Summary")
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                KeyValueRowView(title: "Date", value: service.date.formatted(date: .abbreviated, time: .omitted))
                KeyValueRowView(title: "Total Cost", value: service.totalCost.formatted(CurrencyFormat.inventory))
                if let developer = service.developer {
                    KeyValueRowView(title: "Developer", value: developer.displayName)
                }
                if service.developerAmountUsed > 0 {
                    let unitLabel = service.developer?.resolvedUnit.displayName ?? ""
                    KeyValueRowView(title: "Developer Used", value: "\(service.developerAmountUsed.formatted(.number)) \(unitLabel)")
                }
                if service.developerRatio > 0 {
                    KeyValueRowView(title: "Developer : Color", value: "\(service.developerRatio.formatted(.number)) : 1")
                }
                if let notes = service.notes, !notes.isEmpty {
                    Text(notes)
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
            }
        }
    }
}
