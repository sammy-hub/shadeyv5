import SwiftUI

struct ServiceFormulaCardView: View {
    let service: Service

    var body: some View {
        let formulaGroups = service.formulaGroupsArray

        return SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                SectionHeaderView(title: "Formulas", subtitle: "Products used in this service.")

                if formulaGroups.isEmpty {
                    if service.formulaItemsArray.isEmpty {
                        Text("No products logged.")
                            .font(.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                    } else {
                        VStack(alignment: .leading) {
                            ForEach(service.formulaItemsArray, id: \.id) { item in
                                ServiceFormulaItemRowView(item: item)
                            }
                        }
                    }
                } else {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.large) {
                        ForEach(formulaGroups, id: \.id) { formula in
                            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                Text(formula.name ?? "Formula")
                                    .font(DesignSystem.Typography.headline)
                                    .foregroundStyle(DesignSystem.textPrimary)

                                if let developer = formula.developer {
                                    Text("Developer: \(developer.displayName)")
                                        .font(DesignSystem.Typography.caption)
                                        .foregroundStyle(DesignSystem.textSecondary)
                                }

                                if formula.developerRatio > 0 {
                                    Text("Mix: \(formula.developerRatio.formatted(.number)) : 1")
                                        .font(DesignSystem.Typography.caption)
                                        .foregroundStyle(DesignSystem.textSecondary)
                                }

                                VStack(alignment: .leading) {
                                    ForEach(formula.formulaItemsArray, id: \.id) { item in
                                        ServiceFormulaItemRowView(item: item)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
