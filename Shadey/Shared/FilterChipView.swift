import SwiftUI

struct FilterChipView: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(isSelected ? Color.white : DesignSystem.textPrimary)
                .frame(minHeight: DesignSystem.Layout.minTapHeight)
                .padding(.horizontal, DesignSystem.Spacing.chipHorizontal)
                .background(isSelected ? DesignSystem.accent : DesignSystem.secondarySurface)
                .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.medium))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                        .stroke(DesignSystem.stroke.opacity(isSelected ? 0 : 1), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(title))
    }
}
