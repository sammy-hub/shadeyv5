import SwiftUI

struct InventoryQuickAdjustView: View {
    let unitLabel: String
    let onAdjust: (Double) -> Void

    var body: some View {
        HStack(spacing: DesignSystem.Spacing.xSmall) {
            Button("Remove 1", systemImage: "minus.circle") {
                onAdjust(-1)
            }
            .buttonStyle(.bordered)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)

            Button("Add 1", systemImage: "plus.circle") {
                onAdjust(1)
            }
            .buttonStyle(.bordered)
            .lineLimit(1)
            .fixedSize(horizontal: true, vertical: false)
        }
        .font(DesignSystem.Typography.caption)
        .accessibilityLabel("Adjust stock in \(unitLabel)")
    }
}
