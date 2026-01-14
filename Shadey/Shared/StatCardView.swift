import SwiftUI

/// A standardized card for displaying statistics with optional delta indicator
struct StatCardView: View {
    let title: String
    let value: String
    let accentColor: Color
    let delta: Delta?
    
    struct Delta {
        let value: String
        let isPositive: Bool
    }
    
    init(
        title: String,
        value: String,
        accentColor: Color = DesignSystem.textPrimary,
        delta: Delta? = nil
    ) {
        self.title = title
        self.value = value
        self.accentColor = accentColor
        self.delta = delta
    }
    
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
                
                if let delta {
                    HStack(spacing: DesignSystem.Spacing.xSmall) {
                        Image(systemName: delta.isPositive ? "arrow.up.right" : "arrow.down.right")
                            .font(.caption2)
                            .foregroundStyle(delta.isPositive ? DesignSystem.positive : DesignSystem.warning)
                        Text(delta.value)
                            .font(DesignSystem.Typography.caption)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
