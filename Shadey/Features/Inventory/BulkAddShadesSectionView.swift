import SwiftUI

struct BulkAddShadesSectionView: View {
    @Bindable var viewModel: InventoryCreationViewModel

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                SectionHeaderView(title: "Bulk Add", subtitle: "Paste codes or code - name per line.")

                FieldContainerView {
                    ZStack(alignment: .topLeading) {
                        TextEditor(text: $viewModel.bulkInput)
                            .frame(minHeight: DesignSystem.Layout.minTapHeight * 3)
                        if viewModel.bulkInput.isEmpty {
                            Text("6N, 6A, 7N or 6N - Natural")
                                .foregroundStyle(DesignSystem.textSecondary)
                                .padding(.top, DesignSystem.Spacing.small)
                                .padding(.leading, DesignSystem.Spacing.xSmall)
                        }
                    }
                }

                Button("Add List", systemImage: "tray.and.arrow.down") {
                    viewModel.addBulkShades()
                }
                .buttonStyle(.bordered)
                .disabled(!viewModel.canAddBulk)
            }
        }
    }
}
