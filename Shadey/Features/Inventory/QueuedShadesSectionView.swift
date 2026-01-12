import SwiftUI

struct QueuedShadesSectionView: View {
    @Bindable var viewModel: InventoryCreationViewModel

    var body: some View {
        if viewModel.pendingShades.isEmpty {
            EmptyView()
        } else {
            SurfaceCardView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                    SectionHeaderView(title: "Queued Shades", subtitle: "Review before saving.")
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
