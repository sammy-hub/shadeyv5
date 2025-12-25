import SwiftUI

struct ProductEditorDetailsSectionView: View {
    @Bindable var viewModel: ProductEditorViewModel

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                SectionHeaderView(title: "Details", subtitle: "Brand, shade, type, and unit.")

                TypeaheadFieldView(
                    "Brand",
                    text: $viewModel.draft.brand,
                    suggestions: viewModel.brandSuggestions,
                    emptyHint: "No matching brands yet.",
                    showCreateOption: viewModel.shouldOfferCreateBrand && !viewModel.hasColorLine,
                    createLabel: "Create",
                    onSelect: viewModel.selectBrand,
                    onCreate: viewModel.selectBrand
                )
                .disabled(viewModel.hasColorLine)

                if !viewModel.isBrandValid {
                    Text("Brand is required.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.warning)
                }

                if viewModel.hasColorLine {
                    Text("Brand is managed by the color line.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }

                if !viewModel.hasColorLine && !viewModel.pinnedBrands.isEmpty {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("Pinned")
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                        ScrollView(.horizontal) {
                            HStack(spacing: DesignSystem.Spacing.small) {
                                ForEach(viewModel.pinnedBrands, id: \.self) { brand in
                                    FilterChipView(title: brand, isSelected: true) {
                                        viewModel.selectBrand(brand)
                                    }
                                }
                            }
                            .padding(.vertical, DesignSystem.Spacing.xSmall)
                        }
                        .scrollIndicators(.hidden)
                    }
                }

                if !viewModel.hasColorLine,
                   viewModel.draft.brand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                   !viewModel.recentBrands.isEmpty {
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                        Text("Recent")
                            .font(DesignSystem.Typography.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                        ScrollView(.horizontal) {
                            HStack(spacing: DesignSystem.Spacing.small) {
                                ForEach(viewModel.recentBrands, id: \.self) { brand in
                                    FilterChipView(title: brand, isSelected: false) {
                                        viewModel.selectBrand(brand)
                                    }
                                }
                            }
                            .padding(.vertical, DesignSystem.Spacing.xSmall)
                        }
                        .scrollIndicators(.hidden)
                    }
                }

                Button(
                    viewModel.isCurrentBrandPinned ? "Unpin Brand" : "Pin Brand",
                    systemImage: viewModel.isCurrentBrandPinned ? "pin.slash" : "pin"
                ) {
                    viewModel.pinCurrentBrand()
                }
                .buttonStyle(.bordered)
                .disabled(viewModel.draft.brand.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .disabled(viewModel.hasColorLine)

                FieldContainerView {
                    TextField("Shade Code", text: $viewModel.draft.shadeCode)
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                }

                TypeaheadFieldView(
                    "Shade Name",
                    text: $viewModel.draft.name,
                    suggestions: viewModel.shadeSuggestions,
                    emptyHint: "No matching shades yet.",
                    showCreateOption: viewModel.shouldOfferCreateShade,
                    createLabel: "Create",
                    onSelect: viewModel.selectShade,
                    onCreate: viewModel.selectShade
                )

                if !viewModel.isNameValid {
                    Text("Shade code or name is required.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.warning)
                }

                FieldContainerView {
                    TextField("Notes (optional)", text: $viewModel.draft.notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }

                TypeaheadFieldView(
                    "Product Type",
                    text: $viewModel.productTypeQuery,
                    suggestions: viewModel.typeSuggestions.map(\.name),
                    emptyHint: "Choose a product type.",
                    showCreateOption: false,
                    showsSuggestionsWhenEmpty: true,
                    createLabel: "",
                    onSelect: { selection in
                        if let type = viewModel.typeSuggestions.first(where: { $0.name == selection }) {
                            viewModel.updateProductType(type)
                        }
                    },
                    onCreate: { _ in },
                    onTextChange: viewModel.updateProductTypeQuery
                )

                FieldContainerView {
                    Picker("Unit", selection: $viewModel.draft.unit) {
                        ForEach(UnitType.allCases) { unit in
                            Text(unit.displayName)
                                .tag(unit)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
        }
    }
}
