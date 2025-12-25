import SwiftUI

struct KeyValueRowView: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(DesignSystem.textSecondary)
            Spacer()
            Text(value)
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(DesignSystem.textPrimary)
        }
        .padding(.vertical, DesignSystem.Spacing.small)
    }
}
