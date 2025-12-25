import Foundation

struct ServiceDraft {
    var date: Date
    var notes: String
    var selections: [FormulaSelection]
    var developer: Product?
    var developerRatio: Double
    var beforePhotoData: Data?
    var afterPhotoData: Data?

    init(
        date: Date = .now,
        notes: String = "",
        selections: [FormulaSelection] = [],
        developer: Product? = nil,
        developerRatio: Double = 1,
        beforePhotoData: Data? = nil,
        afterPhotoData: Data? = nil
    ) {
        self.date = date
        self.notes = notes
        self.selections = selections
        self.developer = developer
        self.developerRatio = developerRatio
        self.beforePhotoData = beforePhotoData
        self.afterPhotoData = afterPhotoData
    }
}
