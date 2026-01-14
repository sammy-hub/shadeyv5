import SwiftUI

struct FormulaDeductionFootnoteView: View {
    let lines: [FormulaDeductionLine]
    let totalDeduction: Double

    private var totalLabel: String {
        let units = Set(lines.map { $0.product.resolvedUnit })
        guard units.count == 1, let unit = units.first else {
            return "Mixed units"
        }
        return "\(totalDeduction.formatted(.number.precision(.fractionLength(2)))) \(unit.displayName)"
    }

    var body: some View {
        if lines.isEmpty {
            EmptyView()
        } else {
            SwiftUI.Section {
                DisclosureGroup("Deduction preview: \(lines.count) items | Total \(totalLabel)") {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        ForEach(lines) { line in
                            HStack(alignment: .top, spacing: DesignSystem.Spacing.small) {
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                                    Text(line.product.displayName)
                                        .font(DesignSystem.Typography.subheadline)
                                        .foregroundStyle(DesignSystem.textPrimary)
                                    Text(line.mode.displayName)
                                        .font(DesignSystem.Typography.caption)
                                        .foregroundStyle(DesignSystem.textSecondary)
                                }
                                Spacer()
                                Text("\(line.amount.formatted(.number.precision(.fractionLength(2)))) \(line.product.resolvedUnit.displayName)")
                                    .font(DesignSystem.Typography.caption)
                                    .foregroundStyle(DesignSystem.textSecondary)
                            }
                        }
                    }
                    .padding(.top, DesignSystem.Spacing.xSmall)
                }
            } header: {
                Text("Inventory Impact")
            }
        }
    }
}
