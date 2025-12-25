import SwiftUI

struct ProductTypeManagerView: View {
    @Bindable var store: ProductTypeStore
    @State private var editorMode: ProductTypeEditorMode?

    var body: some View {
        let builtInTypes = store.builtInDefinitions
        let customTypes = store.customDefinitions

        return List {
            Section("Built-in") {
                ForEach(builtInTypes) { type in
                    Button {
                        editorMode = .edit(type)
                    } label: {
                        ProductTypeRowView(type: type)
                    }
                    .buttonStyle(.plain)
                }
            }

            Section("Custom") {
                if customTypes.isEmpty {
                    Text("Add custom types like Gloss or Toner.")
                        .font(.subheadline)
                        .foregroundStyle(DesignSystem.textSecondary)
                } else {
                    ForEach(customTypes) { type in
                        Button {
                            editorMode = .edit(type)
                        } label: {
                            ProductTypeRowView(type: type)
                        }
                        .buttonStyle(.plain)
                    }
                    .onDelete { offsets in
                        offsets.map { customTypes[$0] }.forEach { type in
                            store.deleteType(type)
                        }
                    }
                }
            }
        }
        .navigationTitle("Product Types")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add", systemImage: "plus") {
                    editorMode = .new
                }
            }
        }
        .sheet(item: $editorMode) { mode in
            ProductTypeEditorView(store: store, mode: mode)
        }
    }
}

struct ProductTypeRowView: View {
    let type: ProductTypeDefinition

    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                Text(type.name)
                    .font(DesignSystem.Typography.subheadline)
                    .foregroundStyle(DesignSystem.textPrimary)
                if type.isDeveloper {
                    Text("Developer")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                } else {
                    Text("Developer : Color \(type.defaultRatio.formatted(.number)) : 1")
                        .font(DesignSystem.Typography.caption)
                        .foregroundStyle(DesignSystem.textSecondary)
                }
            }
            Spacer()
            if !type.isBuiltIn {
                Text("Custom")
                    .font(DesignSystem.Typography.caption)
                    .foregroundStyle(DesignSystem.textSecondary)
            }
        }
    }
}

enum ProductTypeEditorMode: Identifiable {
    case new
    case edit(ProductTypeDefinition)

    var id: String {
        switch self {
        case .new:
            return "new"
        case .edit(let type):
            return type.id
        }
    }
}
