import SwiftUI

struct FieldContainerView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .frame(minHeight: DesignSystem.Layout.minTapHeight)
            .padding(.horizontal, DesignSystem.Spacing.fieldPadding)
            .padding(.vertical, DesignSystem.Spacing.small)
            .background(DesignSystem.surface)
            .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.medium))
            .overlay(
                RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                    .stroke(DesignSystem.stroke, lineWidth: 1)
            )
    }
}
