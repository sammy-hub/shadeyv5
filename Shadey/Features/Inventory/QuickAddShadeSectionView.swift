import SwiftUI

struct QuickAddShadeSectionView: View {
    @Bindable var viewModel: InventoryCreationViewModel

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                SectionHeaderView(title: "Add Shade", subtitle: "Tap Add to queue shades quickly.")

                FieldContainerView {
                    TextField("Shade Code (e.g., 6N)", text: $viewModel.shadeDraft.shadeCode)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                }

                FieldContainerView {
                    TextField("Shade Name / Tonal Family", text: $viewModel.shadeDraft.shadeName)
                        .textInputAutocapitalization(.words)
                }

                FieldContainerView {
                    OptionalNumberField("Stock (optional)", value: $viewModel.shadeDraft.stockQuantity, format: .number)
                }

                DisclosureGroup("More details") {
                    FieldContainerView {
                        TextField("Notes (optional)", text: $viewModel.shadeDraft.notes, axis: .vertical)
                            .lineLimit(3, reservesSpace: true)
                    }
                    .padding(.top, DesignSystem.Spacing.small)
                }

                if !viewModel.isShadeValid {
                    Text("Add a shade code or name.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.warning)
                }

                Button("Add Shade", systemImage: "plus") {
                    viewModel.addShade()
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.canAddShade)

            }
        }
    }
}
