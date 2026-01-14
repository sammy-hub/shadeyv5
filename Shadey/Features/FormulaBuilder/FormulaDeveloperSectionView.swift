import SwiftUI

struct FormulaDeveloperSectionView: View {
    @Bindable var viewModel: ServiceEditorViewModel
    let formula: ServiceFormulaDraft

    var body: some View {
        let developerBinding = Binding<UUID?>(
            get: { formula.usesDefaultDeveloper ? nil : formula.developer?.id },
            set: { viewModel.updateDeveloperSelection($0, formulaId: formula.id) }
        )

        let usesSuggestedRatio = Binding<Bool>(
            get: { !formula.isDeveloperRatioOverridden },
            set: { viewModel.setDeveloperRatioOverride(!$0, formulaId: formula.id) }
        )

        let ratioBinding = Binding<Double>(
            get: { viewModel.activeDeveloperRatio(for: formula) },
            set: { viewModel.updateDeveloperRatio($0, formulaId: formula.id) }
        )

        SwiftUI.Section {
            if formula.selections.isEmpty {
                Text("Add products to see developer recommendations.")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            } else {
                Picker("Developer", selection: developerBinding) {
                    Text("Suggested").tag(nil as UUID?)
                    ForEach(viewModel.availableDeveloperProducts, id: \.id) { developer in
                        Text(viewModel.developerLabel(for: developer) ?? developer.displayName)
                            .tag(Optional(developer.id))
                    }
                }
                .pickerStyle(.menu)

                Toggle("Use recommended ratio", isOn: usesSuggestedRatio)

                if !usesSuggestedRatio.wrappedValue {
                    HStack(alignment: .firstTextBaseline, spacing: DesignSystem.Spacing.small) {
                        Text("Ratio")
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                        Spacer()
                        TextField("Ratio", value: ratioBinding, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 90)
                        Text(": 1")
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                }

                if let strength = viewModel.recommendedDeveloperStrength(for: formula) {
                    Text("Suggested strength: \(strength.displayName)")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
            }
        } header: {
            Text("Developer")
        } footer: {
            Text("Adjust developer selection and ratio when needed.")
        }
    }
}
