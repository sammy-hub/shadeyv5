import Foundation

@MainActor
enum PreviewDataFactory {
    static func makeAppData() -> AppData {
        let persistence = PersistenceController.preview
        PreviewDataSeeder.seed(into: persistence.viewContext)
        return AppData(persistence: persistence)
    }
}
