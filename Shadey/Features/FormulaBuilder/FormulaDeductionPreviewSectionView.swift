import SwiftUI

struct FormulaDeductionFootnoteView: View {
    let lines: [FormulaDeductionLine]
    let totalDeduction: Double

    var body: some View {
        Group {
            if lines.isEmpty {
                EmptyView()
            } else {
                DisclosureGroup {
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
                } label: {
                    Text("Deduction preview: \(lines.count) items | Total \(totalLabel)")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
                .padding(.vertical, DesignSystem.Spacing.small)
            }
        }
    }

    private var totalLabel: String {
        let units = Set(lines.map { $0.product.resolvedUnit })
        if units.count == 1, let unit = units.first {
            return "\(totalDeduction.formatted(.number.precision(.fractionLength(2)))) \(unit.displayName)"
        } else {
            return "Mixed units"
        }
    }
}
