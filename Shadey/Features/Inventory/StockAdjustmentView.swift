import SwiftUI

struct StockAdjustmentView: View {
    let store: InventoryStore
    let product: Product

    @Environment(\.dismiss) private var dismiss
    @State private var adjustmentType: AdjustmentType = .add
    @State private var amount: Double?

    init(store: InventoryStore, product: Product, initialAdjustmentType: AdjustmentType = .add) {
        self.store = store
        self.product = product
        _adjustmentType = State(initialValue: initialAdjustmentType)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Action", selection: $adjustmentType) {
                        ForEach(AdjustmentType.allCases) { type in
                            Text(type.displayName)
                                .tag(type)
                        }
                    }
                    OptionalNumberField("Amount", value: $amount, format: .number)
                } header: {
                    Text("Update Stock")
                } footer: {
                    Text("Values use \(product.resolvedUnit.displayName) for this product.")
                }
            }
            .navigationTitle("Adjust Stock")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Apply") {
                        guard let amount else { return }
                        store.adjustStock(for: product, by: amount * adjustmentType.multiplier)
                        dismiss()
                    }
                    .disabled((amount ?? 0) <= 0)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
            }
        }
    }
}
