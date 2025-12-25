import SwiftUI

#Preview {
    let appData = PreviewDataFactory.makeAppData()
    return RootTabView(appData: appData)
        .environment(appData)
        .environment(\.managedObjectContext, appData.persistence.viewContext)
}
