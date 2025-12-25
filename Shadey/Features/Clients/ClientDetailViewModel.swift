import Foundation
import Observation

@MainActor
@Observable
final class ClientDetailViewModel {
    let client: Client
    let store: ClientsStore

    init(client: Client, store: ClientsStore) {
        self.client = client
        self.store = store
    }

    var services: [Service] {
        client.sortedServices
    }

    var totalVisits: Int {
        services.count
    }

    var totalSpend: Double {
        services.reduce(0) { $0 + $1.totalCost }
    }

    func addService(draft: ServiceDraft) {
        store.addService(to: client, draft: draft)
    }

    func deleteClient() {
        store.delete(client: client)
    }
}
