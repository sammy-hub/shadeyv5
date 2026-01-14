import Charts
import SwiftUI

struct ValueByBrandChartView: View {
    let data: [(String, Double)]

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            Text("Inventory Value by Brand")
                .font(DesignSystem.Typography.headline)
                .foregroundStyle(DesignSystem.textPrimary)
            
            Chart {
                ForEach(data, id: \.0) { entry in
                    BarMark(
                        x: .value("Brand", entry.0),
                        y: .value("Value", entry.1)
                    )
                    .foregroundStyle(.tint)
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
            .accessibilityLabel("Inventory Value by Brand Chart")
            .accessibilityValue(chartAccessibilitySummary)
            
            Text(chartAccessibilitySummary)
                .font(DesignSystem.Typography.caption)
                .foregroundStyle(DesignSystem.textSecondary)
                .accessibilityHidden(true)
        }
    }
    
    private var chartAccessibilitySummary: String {
        guard !data.isEmpty else {
            return "No inventory value data available"
        }
        let total = data.reduce(0) { $0 + $1.1 }
        let totalText = total.formatted(AppFormatters.currency)
        let topBrand = data.max(by: { $0.1 < $1.1 })
        if let topBrand {
            let topValue = topBrand.1.formatted(AppFormatters.currency)
            return "Total inventory value: \(totalText). Highest: \(topBrand.0) with \(topValue)."
        }
        return "Total inventory value: \(totalText) across \(data.count) brands."
    }
}
