import Foundation

struct ServiceBrandGroup: Identifiable {
    let id: String
    let brand: String
    let lines: [ServiceLineGroup]
}
