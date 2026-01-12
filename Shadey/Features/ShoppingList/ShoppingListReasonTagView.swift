import SwiftUI

struct ShoppingListReasonTagView: View {
    let reason: ShoppingListItemReason

    var body: some View {
        Text(reason.displayName)
            .font(DesignSystem.Typography.caption)
            .foregroundStyle(DesignSystem.textPrimary)
            .padding(.horizontal, DesignSystem.Spacing.small)
            .padding(.vertical, DesignSystem.Spacing.xSmall)
            .background(DesignSystem.secondarySurface)
            .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.small))
    }
}
