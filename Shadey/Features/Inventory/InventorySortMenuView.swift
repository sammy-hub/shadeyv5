import SwiftUI

struct InventorySortMenuView: View {
    @Binding var sortOption: ProductSortOption

    var body: some View {
        Menu {
            Picker("Sort", selection: $sortOption) {
                ForEach(ProductSortOption.allCases) { option in
                    Text(option.displayName)
                        .tag(option)
                }
            }
        } label: {
            Label("Sort", systemImage: "arrow.up.arrow.down")
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(DesignSystem.textPrimary)
                .frame(minHeight: DesignSystem.Layout.minTapHeight)
                .padding(.horizontal, DesignSystem.Spacing.chipHorizontal)
                .background(DesignSystem.secondarySurface)
                .clipShape(.rect(cornerRadius: DesignSystem.CornerRadius.medium))
                .overlay(
                    RoundedRectangle(cornerRadius: DesignSystem.CornerRadius.medium)
                        .stroke(DesignSystem.stroke, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
