import SwiftUI

struct ScannerOverlayView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
            .stroke(style: StrokeStyle(lineWidth: 2, dash: [8, 6]))
            .foregroundStyle(DesignSystem.accent.opacity(0.6))
            .padding(DesignSystem.Spacing.large)
    }
}
