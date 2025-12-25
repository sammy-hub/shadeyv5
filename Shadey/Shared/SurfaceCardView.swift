import SwiftUI

struct SurfaceCardView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .padding(DesignSystem.Spacing.cardPadding)
            .background(DesignSystem.surface)
            .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.large))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.large)
                    .stroke(DesignSystem.stroke, lineWidth: 1)
            )
            .shadow(color: DesignSystem.stroke.opacity(0.4), radius: 10, x: 0, y: 6)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
