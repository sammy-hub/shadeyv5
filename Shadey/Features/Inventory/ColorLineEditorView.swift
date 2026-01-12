import SwiftUI

struct ColorLineEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ColorLineEditorViewModel

    init(store: InventoryStore, line: ColorLine? = nil) {
        _viewModel = State(initialValue: ColorLineEditorViewModel(store: store, line: line))
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        return NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sectionSpacing) {
                    SurfaceCardView {
                        VStack(alignment: .leading, spacing: DesignSystem.Spacing.medium) {
                            SectionHeaderView(title: "Color Line", subtitle: "Defaults applied to every shade.")

                            TypeaheadFieldView(
                                "Brand",
                                text: $viewModel.lineDraft.brand,
                                suggestions: viewModel.brandSuggestions,
                                emptyHint: "No matching brands yet.",
                                showCreateOption: false,
                                createLabel: "",
                                onSelect: viewModel.updateBrand,
                                onCreate: viewModel.updateBrand,
                                onTextChange: viewModel.updateBrand
                            )

                            TypeaheadFieldView(
                                "Line",
                                text: $viewModel.lineDraft.name,
                                suggestions: viewModel.lineSuggestions,
                                emptyHint: "No matching lines yet.",
                                showCreateOption: false,
                                createLabel: "",
                                onSelect: viewModel.updateLineName,
                                onCreate: viewModel.updateLineName,
                                onTextChange: viewModel.updateLineName
                            )

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

                            DisclosureGroup("Defaults") {
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.small) {
                                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                                        FieldContainerView {
                                            OptionalNumberField(
                                                "Amount in each unit",
                                                value: $viewModel.lineDraft.quantityPerUnit,
                                                format: .number
                                            )
                                        }
                                        Text("Enter how many \(viewModel.lineDraft.unit.displayName) are in one bottle or tube.")
                                            .font(DesignSystem.Typography.caption)
                                            .foregroundStyle(DesignSystem.textSecondary)
                                    }

                                    FieldContainerView {
                                        OptionalNumberField(
                                            "Purchase Price",
                                            value: $viewModel.lineDraft.purchasePrice,
                                            format: CurrencyFormat.inventory
                                        )
                                    }

                                    if !viewModel.isLineDeveloperType {
                                        if viewModel.developerOptions.isEmpty {
                                            Text("Add a developer product to assign a default.")
                                                .font(DesignSystem.Typography.caption)
                                                .foregroundStyle(DesignSystem.textSecondary)
                                        } else {
                                            FieldContainerView {
                                                Picker("Default Developer", selection: $viewModel.lineDraft.defaultDeveloperId) {
                                                    Text("No default")
                                                        .tag(nil as UUID?)
                                                    ForEach(viewModel.developerOptions, id: \.id) { developer in
                                                        Text(viewModel.developerLabel(for: developer))
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
                                .padding(.top, DesignSystem.Spacing.small)
                            }
                        }
                    }
                }
                .padding(.horizontal, DesignSystem.Spacing.pagePadding)
                .padding(.vertical, DesignSystem.Spacing.large)
            }
            .background(DesignSystem.background)
            .scrollIndicators(.hidden)
            .navigationTitle(viewModel.selectedLine == nil ? "New Color Line" : "Edit Color Line")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.save()
                        dismiss()
                    }
                    .disabled(!viewModel.isLineValid || !viewModel.isLineDefaultsComplete)
                }
            }
        }
    }
}
