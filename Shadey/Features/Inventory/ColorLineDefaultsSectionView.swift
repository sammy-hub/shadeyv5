import SwiftUI

struct ColorLineDefaultsSectionView: View {
    @Bindable var viewModel: InventoryCreationViewModel
    let onAddDeveloper: () -> Void

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                SectionHeaderView(title: "Line Defaults", subtitle: "Set once for this color line.")

                if let line = viewModel.selectedLine {
                    Text("Editing \(line.name)")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }

                TypeaheadFieldView(
                    "Brand",
                    text: $viewModel.lineDraft.brand,
                    suggestions: viewModel.brandSuggestions,
                    emptyHint: "No matching brands yet.",
                    showCreateOption: false,
                    createLabel: "",
                    onSelect: viewModel.selectBrand,
                    onCreate: viewModel.selectBrand,
                    onTextChange: viewModel.updateBrand
                )

                if !viewModel.isBrandValid {
                    Text("Brand is required.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.warning)
                } else if viewModel.shouldOfferCreateBrand {
                    Text("New brand will be created when you save.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }

                TypeaheadFieldView(
                    "Color Line",
                    text: $viewModel.lineDraft.name,
                    suggestions: viewModel.lineSuggestions,
                    emptyHint: "No matching lines yet.",
                    showCreateOption: false,
                    createLabel: "",
                    onSelect: viewModel.selectLineName,
                    onCreate: viewModel.selectLineName,
                    onTextChange: viewModel.updateLineName
                )

                if !viewModel.isLineNameValid {
                    Text("Color line is required.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.warning)
                } else if viewModel.shouldOfferCreateLine {
                    Text("New color line will be created when you save.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
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
                    Picker("Unit", selection: $viewModel.lineDraft.unit) {
                        ForEach(UnitType.allCases) { unit in
                            Text(unit.displayName)
                                .tag(unit)
                        }
                    }
                    .pickerStyle(.menu)
                }

                FieldContainerView {
                    OptionalNumberField("Quantity per Unit", value: $viewModel.lineDraft.quantityPerUnit, format: .number)
                }

                FieldContainerView {
                    OptionalNumberField("Purchase Price", value: $viewModel.lineDraft.purchasePrice, format: CurrencyFormat.inventory)
                }

                if !viewModel.isLineDeveloperType {
                    if viewModel.developerOptions.isEmpty {
                        Text("Add a developer product to assign a default.")
                            .font(DesignSystem.Typography.caption)
                            .foregroundStyle(DesignSystem.textSecondary)
                        Button("Add Developer", systemImage: "plus") {
                            onAddDeveloper()
                        }
                        .buttonStyle(.bordered)
                    } else {
                        FieldContainerView {
                            Picker("Default Developer", selection: $viewModel.lineDraft.defaultDeveloperId) {
                                Text("Auto (best match)")
                                    .tag(nil as UUID?)
                                ForEach(viewModel.developerOptions, id: \.id) { developer in
                                    Text(developer.displayName)
                                        .tag(Optional(developer.id))
                                }
                            }
                            .pickerStyle(.menu)
                        }
                    }

                    DeveloperRatioFieldView(
                        title: "Developer : Color",
                        developerPart: $viewModel.developerRatioDeveloperPart,
                        colorPart: $viewModel.developerRatioColorPart,
                        helperText: "Sets the default mix for services."
                    )
                }

                if let cost = viewModel.lineCostPerUnit {
                    Text("Cost per \(viewModel.lineDraft.unit.displayName): \(cost.formatted(CurrencyFormat.inventory))")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
                if let hint = viewModel.lineDefaultsHint {
                    Text(hint)
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
            }
        }
    }
}
