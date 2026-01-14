import SwiftUI

struct ServiceDetailsSectionView: View {
    @Bindable var viewModel: ServiceEditorViewModel

    var body: some View {
        Section {
            DatePicker("Date", selection: $viewModel.draft.date, displayedComponents: .date)
                .accessibilityIdentifier("serviceDatePicker")
            TextField("Notes", text: $viewModel.draft.notes, axis: .vertical)
                .lineLimit(2...5)
                .accessibilityIdentifier("serviceNotesField")
        } header: {
            Text("Service Details")
        } footer: {
            Text("Date and notes for this visit.")
        }
    }
}
