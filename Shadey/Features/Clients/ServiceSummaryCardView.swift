import SwiftUI

struct ServiceSummaryCardView: View {
    let service: Service
    @AppStorage(SettingsKeys.preferredUnit) private var preferredUnitRaw = UnitType.ounces.rawValue

    private var preferredUnit: UnitType {
        UnitType(rawValue: preferredUnitRaw) ?? .ounces
    }

    var body: some View {
        let formulaGroups = service.formulaGroupsArray

        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("Service Summary")
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                KeyValueRowView(title: "Date", value: service.date.formatted(date: .abbreviated, time: .omitted))
                KeyValueRowView(title: "Total Cost", value: service.totalCost.formatted(CurrencyFormat.inventory))
                if !formulaGroups.isEmpty {
                    KeyValueRowView(title: "Formulas", value: "\(formulaGroups.count)")
                } else {
                    if let developer = service.developer {
                        KeyValueRowView(title: "Developer", value: developer.displayName)
                    }
                    if service.developerAmountUsed > 0 {
                        let developerUnit = service.developer?.resolvedUnit ?? preferredUnit
                        let displayAmount = developerUnit.converted(service.developerAmountUsed, to: preferredUnit)
                        KeyValueRowView(
                            title: "Developer Used",
                            value: "\(displayAmount.formatted(.number)) \(preferredUnit.displayName)"
                        )
                    }
                    if service.developerRatio > 0 {
                        KeyValueRowView(title: "Developer : Color", value: "\(service.developerRatio.formatted(.number)) : 1")
                    }
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
