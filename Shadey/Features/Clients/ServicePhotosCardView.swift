import SwiftUI

struct ServicePhotosCardView: View {
    let beforeData: Data?
    let afterData: Data?

    var body: some View {
        if beforeData != nil || afterData != nil {
            SurfaceCardView {
                VStack(alignment: .leading) {
                    SectionHeaderView(title: "Photos", subtitle: "Before and after reference")
                    HStack {
                        PhotoPreviewView(label: "Before", imageData: beforeData)
                        PhotoPreviewView(label: "After", imageData: afterData)
                    }
                }
            }
        }
    }
}
