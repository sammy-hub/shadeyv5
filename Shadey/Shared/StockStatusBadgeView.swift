import SwiftUI

struct StockStatusBadgeView: View {
    let status: StockStatus

    var body: some View {
        switch status {
        case .low:
            Text("Low")
                .font(DesignSystem.Typography.caption)
                .bold()
                .foregroundStyle(DesignSystem.warning)
                .padding(.horizontal, DesignSystem.Spacing.chipHorizontal)
                .padding(.vertical, DesignSystem.Spacing.chipVertical)
                .background(DesignSystem.warning.opacity(0.12))
                .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.small))
        case .overstock:
            Text("Overstock")
                .font(DesignSystem.Typography.caption)
                .bold()
                .foregroundStyle(DesignSystem.positive)
                .padding(.horizontal, DesignSystem.Spacing.chipHorizontal)
                .padding(.vertical, DesignSystem.Spacing.chipVertical)
                .background(DesignSystem.positive.opacity(0.12))
                .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.small))
        case .normal:
            EmptyView()
        }
    }
}
