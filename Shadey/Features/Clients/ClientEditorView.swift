import SwiftUI

struct ClientEditorView: View {
    let store: ClientsStore
    let client: Client?

    @Environment(\.dismiss) private var dismiss
    @State private var name: String
    @State private var notes: String

    init(store: ClientsStore, client: Client? = nil) {
        self.store = store
        self.client = client
        _name = State(initialValue: client?.name ?? "")
        _notes = State(initialValue: client?.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                    TextField("Notes", text: $notes, axis: .vertical)
                } header: {
                    Text("Client")
                }
            }
            .navigationTitle(client == nil ? "Add Client" : "Edit Client")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        if let client {
                            store.update(client: client, name: name, notes: notes)
                        } else {
                            store.addClient(name: name, notes: notes)
                        }
                        dismiss()
                    }
                    .disabled(name.isEmpty)
                }
            }
        }
    }
}
