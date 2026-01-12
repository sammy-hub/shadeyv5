import SwiftUI

struct ProductEditorDeveloperGuidanceSectionView: View {
    @Bindable var viewModel: ProductEditorViewModel

    var body: some View {
        let ratioLabel = viewModel.isLightenerType ? "Mix Ratio" : "Default Ratio"

        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                SectionHeaderView(title: "Developer Guidance", subtitle: "Defaults for formulas.")

                FieldContainerView {
                    OptionalNumberField(ratioLabel, value: $viewModel.draft.defaultDeveloperRatio, format: .number)
                }

                if viewModel.isHairColorType {
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
}
