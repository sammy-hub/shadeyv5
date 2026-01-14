import SwiftUI

struct ClientServiceRowView: View {
    let service: Service

    var body: some View {
        SurfaceCardView {
            HStack {
                VStack(alignment: .leading) {
                    Text(service.date.formatted(AppFormatters.dateAbbreviated))
                        .font(DesignSystem.Typography.headline)
                        .foregroundStyle(DesignSystem.textPrimary)
                    Text("\(service.formulaItems?.count ?? 0) products")
                        .font(DesignSystem.Typography.subheadline)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
                Spacer()
                Text(service.totalCost.formatted(AppFormatters.currency))
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
            }
        }
    }
}
