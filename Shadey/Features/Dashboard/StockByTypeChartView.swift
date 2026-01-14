import Charts
import SwiftUI

struct StockByTypeChartView: View {
    let data: [(ProductTypeDefinition, Double)]

    var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
            Text("Stock by Type")
                .font(DesignSystem.Typography.headline)
                .foregroundStyle(DesignSystem.textPrimary)
            
            Chart {
                ForEach(data, id: \.0.id) { entry in
                    BarMark(
                        x: .value("Type", entry.0.name),
                        y: .value("Stock", entry.1)
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
            .accessibilityLabel("Stock by Type Chart")
            .accessibilityValue(chartAccessibilitySummary)
            
            Text(chartAccessibilitySummary)
                .font(DesignSystem.Typography.caption)
                .foregroundStyle(DesignSystem.textSecondary)
                .accessibilityHidden(true)
        }
    }
    
    private var chartAccessibilitySummary: String {
        guard !data.isEmpty else {
            return "No stock data available"
        }
        let total = data.reduce(0) { $0 + $1.1 }
        let totalText = total.formatted(.number.precision(.fractionLength(0)))
        let topType = data.max(by: { $0.1 < $1.1 })
        if let topType {
            let topText = topType.1.formatted(.number.precision(.fractionLength(0)))
            return "Total stock: \(totalText) units. Highest: \(topType.0.name) with \(topText) units."
        }
        return "Total stock: \(totalText) units across \(data.count) categories."
    }
}
