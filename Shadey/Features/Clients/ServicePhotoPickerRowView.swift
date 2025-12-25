import PhotosUI
import SwiftUI

struct ServicePhotoPickerRowView: View {
    let label: String
    let previewData: Data?
    @Binding var selection: PhotosPickerItem?

    var body: some View {
        VStack(alignment: .leading) {
            PhotosPicker(selection: $selection, matching: .images) {
                Text("Select \(label) Photo")
            }
            PhotoPreviewView(label: label, imageData: previewData)
        }
    }
}
