import Foundation

struct ServiceDraft {
    var date: Date
    var notes: String
    var formulas: [ServiceFormulaDraft]
    var beforePhotoData: Data?
    var afterPhotoData: Data?

    init(
        date: Date = .now,
        notes: String = "",
        formulas: [ServiceFormulaDraft] = [ServiceFormulaDraft(name: "Formula 1")],
        beforePhotoData: Data? = nil,
        afterPhotoData: Data? = nil
    ) {
        self.date = date
        self.notes = notes
        self.formulas = formulas
        self.beforePhotoData = beforePhotoData
        self.afterPhotoData = afterPhotoData
    }
}
