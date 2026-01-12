import SwiftUI

struct InventoryScanNotFoundView: View {
    let barcode: String
    let onAddProduct: () -> Void

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                Text("No Match Found")
                    .font(DesignSystem.Typography.headline)
                    .foregroundStyle(DesignSystem.textPrimary)
                Text("Barcode: \(barcode)")
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textSecondary)
                Button("Quick Add", systemImage: "plus") {
                    onAddProduct()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}
