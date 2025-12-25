import SwiftUI

@main
struct ShadeyApp: App {
    @State private var appData = AppData()

    var body: some Scene {
        WindowGroup {
            RootTabView(appData: appData)
                .environment(appData)
                .environment(\.managedObjectContext, appData.persistence.viewContext)
        }
    }
}
