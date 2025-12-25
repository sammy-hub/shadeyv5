import Charts
import SwiftUI

struct UsageTrendChartView: View {
    let data: [(String, Int)]

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading) {
                SectionHeaderView(title: "Usage Trends", subtitle: "Services logged by month")
                Chart {
                    ForEach(data, id: \.0) { entry in
                        LineMark(
                            x: .value("Month", entry.0),
                            y: .value("Services", entry.1)
                        )
                        .foregroundStyle(DesignSystem.accent)
                        PointMark(
                            x: .value("Month", entry.0),
                            y: .value("Services", entry.1)
                        )
                        .foregroundStyle(DesignSystem.accent)
                    }
                }
                .frame(height: 200)
            }
        }
    }
}
