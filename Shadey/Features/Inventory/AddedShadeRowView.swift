import SwiftUI

struct AddedShadeRowView: View {
    let shade: ShadeDraft
    let onDuplicate: () -> Void
    let onRemove: () -> Void

    var body: some View {
        let label = shadeLabel(from: shade)

        return VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
            Text(label)
                .font(DesignSystem.Typography.subheadline)
                .foregroundStyle(DesignSystem.textPrimary)
            if let stock = shade.stockQuantity {
                Text("Stock: \(stock.formatted(.number))")
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
            HStack(spacing: DesignSystem.Spacing.small) {
                Button("Duplicate", systemImage: "plus.square.on.square") {
                    onDuplicate()
                }
                .buttonStyle(.bordered)

                Button("Remove", systemImage: "trash") {
                    onRemove()
                }
                .buttonStyle(.bordered)
                .tint(DesignSystem.warning)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, DesignSystem.Spacing.small)
    }

    private func shadeLabel(from shade: ShadeDraft) -> String {
        let code = shade.shadeCode.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = shade.shadeName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !code.isEmpty {
            if name.isEmpty || name.localizedStandardCompare(code) == .orderedSame {
                return code
            }
            return "\(code) - \(name)"
        }
        return name
    }
}
