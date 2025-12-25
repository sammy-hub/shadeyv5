import SwiftUI

struct ProductEditorDeveloperGuidanceSectionView: View {
    @Bindable var viewModel: ProductEditorViewModel

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                SectionHeaderView(title: "Developer Guidance", subtitle: "Defaults for formulas.")

                FieldContainerView {
                    OptionalNumberField("Default Ratio", value: $viewModel.draft.defaultDeveloperRatio, format: .number)
                }

                FieldContainerView {
                    Picker("Recommended Strength", selection: $viewModel.draft.recommendedDeveloperStrength) {
                        Text("None").tag(nil as DeveloperStrength?)
                        ForEach(DeveloperStrength.allCases) { strength in
                            Text(strength.displayName)
                                .tag(Optional(strength))
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
        }
    }
}
