import SwiftUI

struct ServiceFormulaCardView: View {
    let service: Service

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading) {
                SectionHeaderView(title: "Formula", subtitle: "Products and ratios used")
                if service.formulaItemsArray.isEmpty {
                    Text("No products logged.")
                        .font(.subheadline)
                        .foregroundStyle(DesignSystem.textSecondary)
                } else {
                    VStack(alignment: .leading) {
                        ForEach(service.formulaItemsArray, id: \.id) { item in
                            ServiceFormulaItemRowView(item: item)
                        }
                    }
                }
            }
        }
    }
}
