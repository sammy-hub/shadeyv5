import SwiftUI

struct ColorLineManagerView: View {
    @Bindable var store: InventoryStore
    @State private var editorMode: ColorLineEditorMode?

    var body: some View {
        let grouped = Dictionary(grouping: store.colorLines) { $0.brand }
        let brands = grouped.keys.sorted { $0.localizedStandardCompare($1) == .orderedAscending }

        return List {
            if brands.isEmpty {
                ContentUnavailableView {
                    Label("No Color Lines", systemImage: "paintbrush")
                } description: {
                    Text("Add inventory to create color lines.")
                }
            } else {
                ForEach(brands, id: \.self) { brand in
                    Section(brand) {
                        let lines = grouped[brand]?.sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending } ?? []
                        ForEach(lines, id: \.id) { line in
                            Button {
                                editorMode = .edit(line)
                            } label: {
                                VStack(alignment: .leading, spacing: DesignSystem.Spacing.xSmall) {
                                    Text(line.name)
                                        .font(DesignSystem.Typography.subheadline)
                                        .foregroundStyle(DesignSystem.textPrimary)
                                    Text("Default ratio \(line.defaultDeveloperRatio.formatted(.number)) : 1")
                                        .font(DesignSystem.Typography.caption)
                                        .foregroundStyle(DesignSystem.textSecondary)
                                }
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .navigationTitle("Color Lines")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add", systemImage: "plus") {
                    editorMode = .new
                }
            }
        }
        .sheet(item: $editorMode) { mode in
            ColorLineEditorView(store: store, line: mode.line)
        }
    }
}

enum ColorLineEditorMode: Identifiable {
    case new
    case edit(ColorLine)

    var id: String {
        switch self {
        case .new:
            return "new"
        case .edit(let line):
            return line.id.uuidString
        }
    }

    var line: ColorLine? {
        switch self {
        case .new:
            return nil
        case .edit(let line):
            return line
        }
    }
}
