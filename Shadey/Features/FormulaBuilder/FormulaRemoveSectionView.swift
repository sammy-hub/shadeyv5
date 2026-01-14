import SwiftUI

struct FormulaRemoveSectionView: View {
    let canRemove: Bool
    let onRemove: () -> Void

    var body: some View {
        Section {
            Button("Remove Formula", role: .destructive) {
                onRemove()
            }
            .disabled(!canRemove)
            .accessibilityIdentifier("removeFormulaButton")
        } footer: {
            if !canRemove {
                Text("At least one formula is required for a service.")
            }
        }
    }
}
