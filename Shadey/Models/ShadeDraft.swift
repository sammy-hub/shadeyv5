import Foundation

struct ShadeDraft: Identifiable, Hashable {
    let id: UUID
    var shadeCode: String
    var shadeName: String
    var notes: String
    var stockQuantity: Double?

    init(
        id: UUID = UUID(),
        shadeCode: String = "",
        shadeName: String = "",
        notes: String = "",
        stockQuantity: Double? = nil
    ) {
        self.id = id
        self.shadeCode = shadeCode
        self.shadeName = shadeName
        self.notes = notes
        self.stockQuantity = stockQuantity
    }
}
