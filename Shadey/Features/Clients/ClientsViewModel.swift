import Foundation
import Observation

@MainActor
@Observable
final class ClientsViewModel {
    let store: ClientsStore
    var searchText: String = ""

    init(store: ClientsStore) {
        self.store = store
    }

    var clients: [Client] {
        store.clients.filter { client in
            guard !searchText.isEmpty else { return true }
            return client.name.localizedStandardContains(searchText)
        }
    }

    func addClient(name: String, notes: String) {
        store.addClient(name: name, notes: notes)
    }

    func client(for id: UUID) -> Client? {
        store.client(id: id)
    }

    func service(for id: UUID) -> Service? {
        store.service(id: id)
    }

    func refresh() {
        store.reload()
    }
}
