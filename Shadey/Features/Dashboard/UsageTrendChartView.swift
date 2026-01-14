import Charts
import SwiftUI

struct UsageTrendChartView: View {
    let data: [(String, Int)]

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            Text("Usage Trends")
                .font(DesignSystem.Typography.headline)
                .foregroundStyle(DesignSystem.textPrimary)
            
            Chart {
                ForEach(data, id: \.0) { entry in
                    LineMark(
                        x: .value("Month", entry.0),
                        y: .value("Services", entry.1)
                    )
                    .foregroundStyle(.tint)
                    .lineStyle(StrokeStyle(lineWidth: 2))
                    PointMark(
                        x: .value("Month", entry.0),
                        y: .value("Services", entry.1)
                    )
                    .foregroundStyle(.tint)
                    .symbolSize(60)
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine()
                    AxisValueLabel()
                        .font(.caption)
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine()
                    AxisValueLabel()
                        .font(.caption)
                }
            }
            .frame(height: ChartStyle.defaultHeight)
            .accessibilityLabel("Usage Trends Chart")
            .accessibilityValue(chartAccessibilitySummary)
            
            Text(chartAccessibilitySummary)
                .font(DesignSystem.Typography.caption)
                .foregroundStyle(DesignSystem.textSecondary)
                .accessibilityHidden(true)
        }
    }
    
    private var chartAccessibilitySummary: String {
        guard !data.isEmpty else {
            return "No usage trend data available"
        }
        let total = data.reduce(0) { $0 + $1.1 }
        let average = total / data.count
        let peak = data.max(by: { $0.1 < $1.1 })
        if let peak {
            return "Total services: \(total) across \(data.count) months. Average: \(average) per month. Peak: \(peak.1) in \(peak.0)."
        }
        return "Total services: \(total) across \(data.count) months."
    }
}
