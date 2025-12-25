import SwiftUI

struct InventoryOverviewCardView: View {
    let title: String
    let value: String
    let accentColor: Color

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                Text(title)
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.textSecondary)
                Text(value)
                    .font(DesignSystem.Typography.headline)
                    .bold()
                    .foregroundStyle(accentColor)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
