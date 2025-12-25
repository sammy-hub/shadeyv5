import SwiftUI

struct ProductTypeEditorView: View {
    let store: ProductTypeStore
    let mode: ProductTypeEditorMode

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var developerPart: Double?
    @State private var colorPart: Double?

    private let isBuiltIn: Bool
    private let isDeveloper: Bool
    private let typeId: String?

    init(store: ProductTypeStore, mode: ProductTypeEditorMode) {
        self.store = store
        self.mode = mode
        switch mode {
        case .new:
            _name = State(initialValue: "")
            _developerPart = State(initialValue: 1)
            _colorPart = State(initialValue: 1)
            isBuiltIn = false
            isDeveloper = false
            typeId = nil
        case .edit(let type):
            _name = State(initialValue: type.name)
            _developerPart = State(initialValue: type.defaultRatio == 0 ? 1 : type.defaultRatio)
            _colorPart = State(initialValue: 1)
            isBuiltIn = type.isBuiltIn
            isDeveloper = type.isDeveloper
            typeId = type.id
        }
    }

    var body: some View {
        let normalizedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let ratioIsValid = isDeveloper || (developerPart ?? 0) > 0 && (colorPart ?? 0) > 0
        let canSave = !normalizedName.isEmpty && ratioIsValid

        let title: String
        switch mode {
        case .new:
            title = "New Type"
        case .edit:
            title = "Edit Type"
        }

        return NavigationStack {
            Form {
                Section("Details") {
                    TextField("Name", text: $name)
                    if isBuiltIn {
                        Text("Built-in types can be renamed and have their default ratios adjusted.")
                            .font(.footnote)
                            .foregroundStyle(DesignSystem.textSecondary)
                    }
                }

                Section("Default Ratio") {
                    if isDeveloper {
                        Text("Developer types don’t use color ratios.")
                            .font(.footnote)
                            .foregroundStyle(DesignSystem.textSecondary)
                    } else {
                        DeveloperRatioFieldView(
                            title: "Developer : Color",
                            developerPart: $developerPart,
                            colorPart: $colorPart,
                            helperText: "Sets the default mix for this type."
                        )
                        if !ratioIsValid {
                            Text("Both parts must be greater than 0.")
                                .font(.footnote)
                                .foregroundStyle(DesignSystem.warning)
                        }
                    }
                }

                if isBuiltIn, let typeId {
                    Section {
                        Button("Reset to Default") {
                            store.resetBuiltIn(typeId)
                            dismiss()
                        }
                        .foregroundStyle(DesignSystem.warning)
                    }
                }

                if !isBuiltIn, let typeId {
                    Section {
                        Button("Delete Type", role: .destructive) {
                            let definition = store.definition(for: typeId)
                            store.deleteType(definition)
                            dismiss()
                        }
                    }
                }
            }
            .navigationTitle(title)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        saveType()
                        dismiss()
                    }
                    .disabled(!canSave)
                }
            }
        }
    }

    private func saveType() {
        let normalizedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let ratio = resolvedRatio()
        switch mode {
        case .new:
            _ = store.addCustomType(name: normalizedName, defaultRatio: ratio)
        case .edit(let type):
            let updated = ProductTypeDefinition(
                id: type.id,
                name: normalizedName,
                defaultRatio: isDeveloper ? 0 : ratio,
                isDeveloper: type.isDeveloper,
                isBuiltIn: type.isBuiltIn
            )
            store.updateType(updated)
        }
    }

    private func resolvedRatio() -> Double {
        guard !isDeveloper else { return 0 }
        guard let developerPart, let colorPart, colorPart > 0 else { return 1 }
        return developerPart / colorPart
    }
}
