import PhotosUI
import SwiftUI

struct ServicePhotoPickerRowView: View {
    let label: String
    let previewData: Data?
    @Binding var selection: PhotosPickerItem?

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            LabeledContent("\(label) Photo") {
                PhotosPicker(selection: $selection, matching: .images) {
                    Text(previewData == nil ? "Add" : "Change")
                }
                .accessibilityLabel("Select \(label) Photo")
            }

            PhotoPreviewView(label: label, imageData: previewData, showsLabel: false)
        }
    }
}
