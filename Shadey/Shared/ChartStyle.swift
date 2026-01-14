import Charts
import SwiftUI

/// Consistent chart styling and configuration
enum ChartStyle {
    static let defaultHeight: CGFloat = 200
    static let compactHeight: CGFloat = 150
    
    static var barForeground: Color {
        DesignSystem.accent
    }
    
    static var lineForeground: Color {
        DesignSystem.accent
    }
    
    static var gridColor: Color {
        DesignSystem.stroke.opacity(0.2)
    }
    
    static var axisColor: Color {
        DesignSystem.textSecondary
    }
    
    /// Applies consistent styling to a chart
    static func applyDefaultStyle<Content: ChartContent>(to chart: Chart<Content>) -> some View {
        chart
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(gridColor)
                    AxisValueLabel()
                        .foregroundStyle(axisColor)
                        .font(DesignSystem.Typography.caption)
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(gridColor)
                    AxisValueLabel()
                        .foregroundStyle(axisColor)
                        .font(DesignSystem.Typography.caption)
                }
            }
            .frame(height: defaultHeight)
    }
    
    /// Applies compact styling (smaller height) to a chart
    static func applyCompactStyle<Content: ChartContent>(to chart: Chart<Content>) -> some View {
        chart
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(gridColor)
                    AxisValueLabel()
                        .foregroundStyle(axisColor)
                        .font(DesignSystem.Typography.caption)
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(gridColor)
                    AxisValueLabel()
                        .foregroundStyle(axisColor)
                        .font(DesignSystem.Typography.caption)
                }
            }
            .frame(height: compactHeight)
    }
}
