import SwiftUI

struct ServiceDetailsSectionView: View {
    @Bindable var viewModel: ServiceEditorViewModel

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                SectionHeaderView(title: "Service Details", subtitle: "Date and notes for this visit.")
                DatePicker("Date", selection: $viewModel.draft.date, displayedComponents: .date)
                TextField("Notes", text: $viewModel.draft.notes, axis: .vertical)
            }
        }
    }
}
