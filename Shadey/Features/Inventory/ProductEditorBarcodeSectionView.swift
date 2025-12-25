import SwiftUI

struct ProductEditorBarcodeSectionView: View {
    @Bindable var viewModel: ProductEditorViewModel

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                SectionHeaderView(title: "Barcode", subtitle: "Optional for quick scanning.")

                FieldContainerView {
                    TextField("Barcode", text: $viewModel.draft.barcode)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
            }
        }
    }
}
