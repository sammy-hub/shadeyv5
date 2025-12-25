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
                    TextField("Notes (optional)", text: $viewModel.shadeDraft.notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }

                FieldContainerView {
                    OptionalNumberField("Stock (optional)", value: $viewModel.shadeDraft.stockQuantity, format: .number)
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

                if !viewModel.pendingShades.isEmpty {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("Queued Shades (\(viewModel.pendingShades.count))")
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                        ForEach(viewModel.pendingShades) { shade in
                            AddedShadeRowView(shade: shade) {
                                viewModel.duplicateShade(shade)
                            } onRemove: {
                                viewModel.removeShade(shade)
                            }
                            if shade.id != viewModel.pendingShades.last?.id {
                                Divider()
                            }
                        }
                    }
                }
            }
        }
    }
}
