import SwiftUI

struct PhotoPreviewView: View {
    let label: String
    let imageData: Data?
    let showsLabel: Bool

    init(label: String, imageData: Data?, showsLabel: Bool = true) {
        self.label = label
        self.imageData = imageData
        self.showsLabel = showsLabel
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
            if showsLabel {
                Text(label)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
            if let imageData, let image = ImageDecoder.image(from: imageData) {
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.medium))
                    .frame(maxWidth: .infinity)
                    .aspectRatio(4.0 / 3.0, contentMode: .fit)
            } else {
                DesignSystem.secondarySurface
                    .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.medium))
                    .overlay {
                        Text("No photo")
                            .font(DesignSystem.Typography.caption)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                    .frame(maxWidth: .infinity)
                    .aspectRatio(4.0 / 3.0, contentMode: .fit)
            }
        }
    }
}
