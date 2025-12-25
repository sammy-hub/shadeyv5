import SwiftUI

struct ServiceFormulaItemRowView: View {
    let item: FormulaItem

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.product?.displayName ?? "Product")
                    .font(.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Text("\(item.amountUsed.formatted(.number)) \(item.product?.resolvedUnit.displayName ?? "")")
                    .font(.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(item.cost, format: CurrencyFormat.inventory)
                    .font(.subheadline)
                    .foregroundStyle(DesignSystem.textPrimary)
                if item.ratioPart > 0 {
                    Text("Part \(item.ratioPart.formatted(.number))")
                        .font(.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
            }
        }
        .padding(.vertical)
    }
}
