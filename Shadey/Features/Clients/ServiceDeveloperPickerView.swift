import SwiftUI

struct ServiceDeveloperPickerView: View {
    let developers: [Product]
    let defaultDeveloperName: String?
    @Binding var selectedDeveloperId: UUID?

    var body: some View {
        Picker("Developer", selection: $selectedDeveloperId) {
            if let defaultDeveloperName {
                Text("Line default (\(defaultDeveloperName))")
                    .tag(nil as UUID?)
            } else {
                Text("Line default")
                    .tag(nil as UUID?)
            }
            ForEach(developers, id: \.id) { developer in
                Text(developer.displayName)
                    .tag(Optional(developer.id))
            }
        }
    }
}
