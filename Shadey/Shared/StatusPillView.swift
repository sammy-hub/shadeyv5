import SwiftUI

struct StatusPillView: View {
    let title: String
    let value: Int
    let color: Color

    var body: some View {
        HStack {
            Text(title)
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(DesignSystem.textSecondary)
            Text("\(value)")
                .font(DesignSystem.Typography.subheadline)
                .bold()
                .foregroundStyle(color)
        }
        .padding(.horizontal, DesignSystem.Spacing.chipHorizontal)
        .padding(.vertical, DesignSystem.Spacing.chipVertical)
        .background(color.opacity(0.12))
        .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.medium))
    }
}
