import SwiftUI

struct InventorySingleProductSectionView: View {
    @Bindable var viewModel: InventoryCreationViewModel
    let category: InventoryCategory

    var body: some View {
        SurfaceCardView {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                SectionHeaderView(title: "\(category.displayName) Details", subtitle: nil)

                TypeaheadFieldView(
                    "Brand",
                    text: $viewModel.singleProductDraft.brand,
                    suggestions: viewModel.singleBrandSuggestions,
                    emptyHint: "No matching brands yet.",
                    showCreateOption: false,
                    createLabel: "",
                    onSelect: { viewModel.singleProductDraft.brand = $0 },
                    onCreate: { viewModel.singleProductDraft.brand = $0 },
                    onTextChange: { viewModel.singleProductDraft.brand = $0 }
                )

                FieldContainerView {
                    TextField("Line", text: $viewModel.singleProductDraft.name)
                }

                FieldContainerView {
                    OptionalNumberField("Amount", value: $viewModel.singleProductDraft.stockQuantity, format: .number)
                }

                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                    FieldContainerView {
                        OptionalNumberField("Amount in each unit", value: $viewModel.singleProductDraft.quantityPerUnit, format: .number)
                    }
                    Text("Enter how many \(viewModel.singleProductDraft.unit.displayName) are in one bottle or tube.")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }

                FieldContainerView {
                    Picker("Unit", selection: $viewModel.singleProductDraft.unit) {
                        ForEach(UnitType.allCases) { unit in
                            Text(unit.displayName)
                                .tag(unit)
                        }
                    }
                    .pickerStyle(.menu)
                }

                FieldContainerView {
                    OptionalNumberField("Price", value: $viewModel.singleProductDraft.purchasePrice, format: CurrencyFormat.inventory)
                }

                if category == .lightener {
                    DeveloperRatioFieldView(
                        title: "Developer : Lightener",
                        developerPart: $viewModel.singleDeveloperRatioDeveloperPart,
                        colorPart: $viewModel.singleDeveloperRatioColorPart,
                        helperText: "Sets the mix ratio for services."
                    )
                }

                if category == .developer {
                    FieldContainerView {
                        Picker("Strength", selection: $viewModel.singleProductDraft.developerStrength) {
                            Text("Not applicable")
                                .tag(nil as DeveloperStrength?)
                            ForEach(DeveloperStrength.allCases) { strength in
                                Text(strength.displayName)
                                    .tag(Optional(strength))
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
        }
    }
}
