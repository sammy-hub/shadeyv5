import PhotosUI
import SwiftUI

struct ServiceEditorView: View {
    let inventoryStore: InventoryStore
    let onSave: (ServiceDraft) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var viewModel: ServiceEditorViewModel
    @State private var beforePhotoItem: PhotosPickerItem?
    @State private var afterPhotoItem: PhotosPickerItem?
    @State private var ratioDeveloperPart: Double?
    @State private var ratioColorPart: Double? = 1

    init(inventoryStore: InventoryStore, onSave: @escaping (ServiceDraft) -> Void) {
        self.inventoryStore = inventoryStore
        self.onSave = onSave
        _viewModel = State(initialValue: ServiceEditorViewModel(inventoryStore: inventoryStore))
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        let ratioOverrideBinding = Binding<Bool>(
            get: { viewModel.isDeveloperRatioOverridden },
            set: { viewModel.setDeveloperRatioOverride($0) }
        )

        return NavigationStack {
            Form {
                Section("Service Details") {
                    DatePicker("Date", selection: $viewModel.draft.date, displayedComponents: .date)
                    TextField("Notes", text: $viewModel.draft.notes, axis: .vertical)
                }

                Section("Formula Products") {
                    if viewModel.availableColorProducts.isEmpty {
                        Text("Add inventory products to build formulas.")
                            .font(.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                    } else {
                        if viewModel.selectionMode == .grouped {
                            ServiceProductGroupListView(
                                groups: viewModel.groupedColorProducts,
                                showsStock: viewModel.showsStockInSelection,
                                typeName: viewModel.typeName(for:),
                                isSelected: { product in
                                    viewModel.draft.selections.contains(where: { $0.product.id == product.id })
                                },
                                onToggle: viewModel.toggleSelection(for:)
                            )
                        } else {
                            ForEach(viewModel.availableColorProducts, id: \.id) { product in
                                ServiceProductSelectionRowView(
                                    product: product,
                                    typeName: viewModel.typeName(for: product),
                                    isSelected: viewModel.draft.selections.contains(where: { $0.product.id == product.id }),
                                    showsBrand: true,
                                    showsStock: viewModel.showsStockInSelection
                                ) {
                                    viewModel.toggleSelection(for: product)
                                }
                            }
                        }
                    }

                    DisclosureGroup("View options") {
                        Picker("View", selection: $viewModel.selectionMode) {
                            ForEach(ServiceProductSelectionMode.allCases) { mode in
                                Text(mode.displayName)
                                    .tag(mode)
                            }
                        }
                        .pickerStyle(.menu)

                        Toggle("Hide out of stock", isOn: $viewModel.hideOutOfStock)
                        Toggle("Show stock levels", isOn: $viewModel.showsStockInSelection)
                    }
                }

                Section("Selected Mix") {
                    if viewModel.draft.selections.isEmpty {
                        Text("Select products to start a formula.")
                            .font(.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                    } else {
                        ForEach(viewModel.draft.selections) { selection in
                            ServiceSelectionEditorRowView(
                                selection: selection,
                                amount: Binding(
                                    get: { selection.amountUsed },
                                    set: { viewModel.updateAmount(for: selection, amount: $0) }
                                ),
                                ratioPart: Binding(
                                    get: { selection.ratioPart },
                                    set: { viewModel.updateRatioPart(for: selection, ratioPart: $0) }
                                )
                            )
                        }
                    }
                }

                Section("Developer") {
                    ServiceDeveloperPickerView(
                        developers: viewModel.availableDeveloperProducts,
                        defaultDeveloperName: viewModel.defaultDeveloper?.displayName,
                        selectedDeveloperId: Binding(
                            get: { viewModel.usesDefaultDeveloper ? nil : viewModel.draft.developer?.id },
                            set: { id in
                                viewModel.updateDeveloperSelection(id)
                            }
                        )
                    )

                    if viewModel.draft.selections.isEmpty {
                        Text("Select a shade to set the default ratio.")
                            .font(.subheadline)
                            .foregroundStyle(DesignSystem.textSecondary)
                    } else {
                        DeveloperRatioSummaryView(
                            ratio: viewModel.activeDeveloperRatio,
                            helperText: viewModel.isDeveloperRatioOverridden ? "Override applied for this service." : "Default from the color line."
                        )
                    }

                    Toggle("Override ratio", isOn: ratioOverrideBinding)

                    if viewModel.isDeveloperRatioOverridden {
                        DeveloperRatioFieldView(
                            title: "Developer : Color",
                            developerPart: $ratioDeveloperPart,
                            colorPart: $ratioColorPart,
                            helperText: "Example: 1 : 1 or 1 : 2."
                        )
                    }
                }

                Section("Photos") {
                    ServicePhotoPickerRowView(label: "Before", previewData: viewModel.draft.beforePhotoData, selection: $beforePhotoItem)
                    ServicePhotoPickerRowView(label: "After", previewData: viewModel.draft.afterPhotoData, selection: $afterPhotoItem)
                }

                Section("Summary") {
                    KeyValueRowView(title: "Developer Amount", value: viewModel.developerAmount.formatted(.number))
                    KeyValueRowView(title: "Total Cost", value: viewModel.totalCost.formatted(CurrencyFormat.inventory))
                }
            }
            .navigationTitle("New Service")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        onSave(viewModel.finalizedDraft())
                        dismiss()
                    }
                    .disabled(viewModel.draft.selections.isEmpty)
                }
            }
            .onChange(of: beforePhotoItem) { _, newValue in
                Task {
                    let data = try? await newValue?.loadTransferable(type: Data.self)
                    await MainActor.run {
                        viewModel.updateBeforePhotoData(data)
                    }
                }
            }
            .onChange(of: afterPhotoItem) { _, newValue in
                Task {
                    let data = try? await newValue?.loadTransferable(type: Data.self)
                    await MainActor.run {
                        viewModel.updateAfterPhotoData(data)
                    }
                }
            }
            .onChange(of: viewModel.isDeveloperRatioOverridden) { _, newValue in
                guard newValue else { return }
                ratioDeveloperPart = viewModel.activeDeveloperRatio == 0 ? 1 : viewModel.activeDeveloperRatio
                ratioColorPart = 1
            }
            .onChange(of: ratioDeveloperPart) { _, newValue in
                guard viewModel.isDeveloperRatioOverridden else { return }
                updateRatioOverride(developerPart: newValue, colorPart: ratioColorPart, viewModel: viewModel)
            }
            .onChange(of: ratioColorPart) { _, newValue in
                guard viewModel.isDeveloperRatioOverridden else { return }
                updateRatioOverride(developerPart: ratioDeveloperPart, colorPart: newValue, viewModel: viewModel)
            }
        }
    }

    private func updateRatioOverride(
        developerPart: Double?,
        colorPart: Double?,
        viewModel: ServiceEditorViewModel
    ) {
        guard let developerPart, let colorPart, colorPart > 0 else { return }
        viewModel.updateDeveloperRatio(developerPart / colorPart)
    }
}
