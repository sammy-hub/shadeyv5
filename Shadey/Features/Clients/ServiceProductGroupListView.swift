import SwiftUI

struct ServiceProductGroupListView: View {
    let groups: [ServiceBrandGroup]
    let showsStock: Bool
    let typeName: (Product) -> String
    let isSelected: (Product) -> Bool
    let onToggle: (Product) -> Void

    @State private var expandedBrands: Set<String> = []
    @State private var expandedLines: Set<String> = []

    var body: some View {
        ForEach(groups) { brandGroup in
            DisclosureGroup(
                isExpanded: binding(for: brandGroup.id, in: $expandedBrands)
            ) {
                ForEach(brandGroup.lines) { lineGroup in
                    DisclosureGroup(
                        isExpanded: binding(for: lineGroup.id, in: $expandedLines)
                    ) {
                        ForEach(lineGroup.products, id: \.id) { product in
                            ServiceProductSelectionRowView(
                                product: product,
                                typeName: typeName(product),
                                isSelected: isSelected(product),
                                showsBrand: false,
                                showsStock: showsStock
                            ) {
                                onToggle(product)
                            }
                        }
                    } label: {
                        HStack {
                            Text(lineGroup.name)
                                .font(DesignSystem.Typography.subheadline)
                                .foregroundStyle(DesignSystem.textPrimary)
                            Spacer()
                            Text("\(lineGroup.shadeCount) shades")
                                .font(DesignSystem.Typography.caption)
                                .foregroundStyle(DesignSystem.textSecondary)
                        }
                    }
                }
            } label: {
                HStack {
                    Text(brandGroup.brand)
                        .font(DesignSystem.Typography.headline)
                        .foregroundStyle(DesignSystem.textPrimary)
                    Spacer()
                    Text("\(brandGroup.lines.count) lines")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
            }
        }
    }

    private func binding(for id: String, in set: Binding<Set<String>>) -> Binding<Bool> {
        Binding(
            get: { set.wrappedValue.contains(id) },
            set: { isExpanded in
                if isExpanded {
                    set.wrappedValue.insert(id)
                } else {
                    set.wrappedValue.remove(id)
                }
            }
        )
    }
}
