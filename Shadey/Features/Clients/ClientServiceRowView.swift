import SwiftUI

struct ClientServiceRowView: View {
    let service: Service

    var body: some View {
        SurfaceCardView {
            HStack {
                VStack(alignment: .leading) {
                    Text(service.date, style: .date)
                        .font(.headline)
                        .foregroundStyle(DesignSystem.textPrimary)
                    Text("\(service.formulaItems?.count ?? 0) products")
                        .font(.subheadline)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
                Spacer()
                Text(service.totalCost, format: CurrencyFormat.inventory)
                    .font(.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
            }
        }
    }
}
