import Foundation
import Observation

@MainActor
@Observable
final class ClientsViewModel {
    enum SortOption: String, CaseIterable, Identifiable {
        case name
        case recentService

        var id: String { rawValue }
 
        var displayName: String {
            switch self {
            case .name:
                return "Name"
            case .recentService:
                return "Recent Service"
            }
        }
    }

    let store: ClientsStore
    var searchText: String = ""
    var sortOption: SortOption = .recentService

    init(store: ClientsStore) {
        self.store = store
    }

    var clients: [Client] {
        let filtered = store.clients.filter { client in
            guard !searchText.isEmpty else { return true }
            return client.name.localizedStandardContains(searchText)
        }

        switch sortOption {
        case .name:
            return filtered.sorted { lhs, rhs in
                lhs.name.localizedStandardCompare(rhs.name) == .orderedAscending
            }
        case .recentService:
            return filtered.sorted { lhs, rhs in
                clientDate(lhs) > clientDate(rhs)
            }
        }
    }

    private func clientDate(_ client: Client) -> Date {
        client.sortedServices.first?.date ?? client.createdAt
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
