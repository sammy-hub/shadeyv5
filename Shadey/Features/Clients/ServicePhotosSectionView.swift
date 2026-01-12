import PhotosUI
import SwiftUI

struct ServicePhotosSectionView: View {
    let beforePhotoData: Data?
    let afterPhotoData: Data?
    @Binding var beforePhotoItem: PhotosPickerItem?
    @Binding var afterPhotoItem: PhotosPickerItem?

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                SectionHeaderView(title: "Photos", subtitle: "Capture before and after.")
                ServicePhotoPickerRowView(label: "Before", previewData: beforePhotoData, selection: $beforePhotoItem)
                ServicePhotoPickerRowView(label: "After", previewData: afterPhotoData, selection: $afterPhotoItem)
            }
        }
    }
}
