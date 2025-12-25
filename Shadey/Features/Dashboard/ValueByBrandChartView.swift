import Charts
import SwiftUI

struct ValueByBrandChartView: View {
    let data: [(String, Double)]

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading) {
                SectionHeaderView(title: "Inventory Value", subtitle: "Estimated value by brand")
                Chart {
                    ForEach(data, id: \.0) { entry in
                        BarMark(
                            x: .value("Brand", entry.0),
                            y: .value("Value", entry.1)
                        )
                        .foregroundStyle(DesignSystem.textSecondary)
                    }
                }
                .frame(height: 200)
            }
        }
    }
}
