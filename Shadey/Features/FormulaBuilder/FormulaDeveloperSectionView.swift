import SwiftUI

struct FormulaDeveloperSectionView: View {
    @Bindable var viewModel: ServiceEditorViewModel
    let formula: ServiceFormulaDraft

    var body: some View {
        let developerBinding = Binding<UUID?>(
            get: { formula.usesDefaultDeveloper ? nil : formula.developer?.id },
            set: { viewModel.updateDeveloperSelection($0, formulaId: formula.id) }
        )

        let ratioBinding = Binding<Double?>(
            get: { viewModel.activeDeveloperRatio(for: formula) },
            set: { viewModel.updateDeveloperRatio($0 ?? 0, formulaId: formula.id) }
        )

        let ratioLabel = viewModel.isLightenerType(formula) ? "Mix ratio" : "Default ratio"

        return VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
            SectionHeaderView(title: "Developer", subtitle: nil)

            if formula.selections.isEmpty {
                Text("Add products to this formula to reveal developer recommendations.")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            } else {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                        Text("Developer")
                            .font(DesignSystem.Typography.caption)
                            .foregroundStyle(DesignSystem.textSecondary)
                        Picker("Developer", selection: developerBinding) {
                            Text("Select Developer")
                                .tag(nil as UUID?)
                            ForEach(viewModel.availableDeveloperProducts, id: \.id) { developer in
                                Text(viewModel.developerLabel(for: developer) ?? developer.displayName)
                                    .tag(Optional(developer.id))
                            }
                        }
                        .pickerStyle(.menu)
                    }

                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                        Text(ratioLabel)
                            .font(DesignSystem.Typography.caption)
                            .foregroundStyle(DesignSystem.textSecondary)
                        Text("Enter how many parts of developer for every 1 part of the formula color.")
                            .font(DesignSystem.Typography.caption)
                            .foregroundStyle(DesignSystem.textSecondary)
                        HStack(spacing: DesignSystem.Spacing.small) {
                            TextField("Ratio", value: ratioBinding, format: .number)
                                .keyboardType(.decimalPad)
                                .textFieldStyle(.roundedBorder)
                                .frame(minWidth: 70)
                            Text(": 1")
                                .font(DesignSystem.Typography.caption)
                                .foregroundStyle(DesignSystem.textSecondary)
                        }
                    }
                }
            }

        }
    }
}
