import Charts
import SwiftUI

struct StockByTypeChartView: View {
    let data: [(ProductTypeDefinition, Double)]

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading) {
                SectionHeaderView(title: "Stock by Type", subtitle: "Units on hand across categories")
                Chart {
                    ForEach(data, id: \.0.id) { entry in
                        BarMark(
                            x: .value("Type", entry.0.name),
                            y: .value("Stock", entry.1)
                        )
                        .foregroundStyle(DesignSystem.accent)
                    }
                }
                .frame(height: 200)
            }
        }
    }
}
