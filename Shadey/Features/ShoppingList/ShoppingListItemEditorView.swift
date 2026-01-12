import SwiftUI

struct ShoppingListItemEditorView: View {
    let item: ShoppingListItem
    let onSave: (Double, String, Bool) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var quantity: Double?
    @State private var note: String
    @State private var isPinned: Bool

    init(item: ShoppingListItem, onSave: @escaping (Double, String, Bool) -> Void) {
        self.item = item
        self.onSave = onSave
        _quantity = State(initialValue: item.quantityNeeded)
        _note = State(initialValue: item.note ?? "")
        _isPinned = State(initialValue: item.isPinned)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    Text(item.product?.displayName ?? "Product")
                    OptionalNumberField("Quantity", value: $quantity, format: .number)
                }

                Section("Notes") {
                    TextField("Note (optional)", text: $note, axis: .vertical)
                }

                Section("Priority") {
                    Toggle("Pinned", isOn: $isPinned)
                }
            }
            .navigationTitle("Edit Item")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let finalQuantity = max(quantity ?? item.quantityNeeded, 0)
                        onSave(finalQuantity, note, isPinned)
                        dismiss()
                    }
                }
            }
        }
    }
}
