import SwiftUI

struct SurfaceCardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(DesignSystem.Spacing.large)
            .background {
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .fill(DesignSystem.surface)
                    .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
