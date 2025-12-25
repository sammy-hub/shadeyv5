import SwiftUI

struct ServiceProductSelectionRowView: View {
    let product: Product
    let typeName: String
    let isSelected: Bool
    let showsBrand: Bool
    let showsStock: Bool
    let onToggle: () -> Void

    var body: some View {
        Button {
            onToggle()
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(showsBrand ? product.displayName : product.shadeLabel)
                        .font(.subheadline)
                        .foregroundStyle(DesignSystem.textPrimary)
                    Text(typeName)
                        .font(.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                    if showsStock {
                        Text("Stock \(product.stockQuantity.formatted(.number)) \(product.resolvedUnit.displayName)")
                            .font(.caption)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                }
                Spacer()
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(DesignSystem.accent)
                } else {
                    Image(systemName: "circle")
                        .foregroundStyle(DesignSystem.secondarySurface)
                }
            }
        }
    }
}
