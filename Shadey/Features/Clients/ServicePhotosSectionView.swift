import PhotosUI
import SwiftUI

struct ServicePhotosSectionView: View {
    let beforePhotoData: Data?
    let afterPhotoData: Data?
    @Binding var beforePhotoItem: PhotosPickerItem?
    @Binding var afterPhotoItem: PhotosPickerItem?

    var body: some View {
        Section {
            ServicePhotoPickerRowView(label: "Before", previewData: beforePhotoData, selection: $beforePhotoItem)
            ServicePhotoPickerRowView(label: "After", previewData: afterPhotoData, selection: $afterPhotoItem)
        } header: {
            Text("Photos")
        } footer: {
            Text("Capture before and after.")
        }
    }
}
