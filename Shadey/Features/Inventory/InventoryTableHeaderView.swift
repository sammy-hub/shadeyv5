import SwiftUI

struct InventoryTableHeaderView: View {
    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack {
                Text("Product")
                Spacer()
                Text("Stock")
                    .frame(width: 90, alignment: .trailing)
                Text("Unit Cost")
                    .frame(width: 90, alignment: .trailing)
            }
            HStack {
                Text("Product")
                Spacer()
                Text("Stock")
                    .frame(width: 90, alignment: .trailing)
            }
        }
        .font(DesignSystem.Typography.caption)
        .foregroundStyle(DesignSystem.textSecondary)
    }
}
