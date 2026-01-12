import SwiftUI

struct ServiceFormulaItemRowView: View {
    let item: FormulaItem
    @AppStorage(SettingsKeys.preferredUnit) private var preferredUnitRaw = UnitType.ounces.rawValue

    private var preferredUnit: UnitType {
        UnitType(rawValue: preferredUnitRaw) ?? .ounces
    }

    var body: some View {
        let productUnit = item.product?.resolvedUnit ?? preferredUnit
        let displayAmount = productUnit.converted(item.amountUsed, to: preferredUnit)
        HStack {
            VStack(alignment: .leading) {
                Text(item.product?.displayName ?? "Product")
                    .font(.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Text("\(displayAmount.formatted(.number)) \(preferredUnit.displayName)")
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
