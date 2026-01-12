import SwiftUI

struct InventoryProductRowView: View {
    let product: Product
    let typeName: String
    let stockStatus: StockStatus

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                NavigationLink(value: product.id) {
                    ProductRowView(
                        product: product,
                        typeName: typeName,
                        stockStatus: stockStatus
                    )
                }
                .buttonStyle(.plain)
            }
        }
    }
}
