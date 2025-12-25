import SwiftUI

struct ProductEditorDeveloperStrengthSectionView: View {
    @Bindable var viewModel: ProductEditorViewModel

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                SectionHeaderView(title: "Developer", subtitle: "Strength and mixing details.")

                FieldContainerView {
                    Picker("Strength", selection: $viewModel.draft.developerStrength) {
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
