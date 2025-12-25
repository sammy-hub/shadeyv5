import CoreData
import Observation

@MainActor
@Observable
final class ClientsStore {
    private let context: NSManagedObjectContext
    private let inventoryStore: InventoryStore
    private(set) var clients: [Client] = []

    init(context: NSManagedObjectContext, inventoryStore: InventoryStore) {
        self.context = context
        self.inventoryStore = inventoryStore
        reload()
    }

    func reload() {
        let request = Client.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Client.name, ascending: true)]
        do {
            clients = try context.fetch(request)
        } catch {
            clients = []
        }
    }

    func addClient(name: String, notes: String) {
        let client = Client(context: context)
        client.id = UUID()
        client.name = name
        client.notes = notes.isEmpty ? nil : notes
        client.createdAt = .now
        saveContext()
        reload()
    }

    func client(id: UUID) -> Client? {
        clients.first { $0.id == id }
    }

    func service(id: UUID) -> Service? {
        for client in clients {
            if let service = client.services?.first(where: { $0.id == id }) {
                return service
            }
        }
        return nil
    }

    func update(client: Client, name: String, notes: String) {
        client.name = name
        client.notes = notes.isEmpty ? nil : notes
        saveContext()
        reload()
    }

    func delete(client: Client) {
        context.delete(client)
        saveContext()
        reload()
    }

    func addService(to client: Client, draft: ServiceDraft) {
        let service = Service(context: context)
        service.id = UUID()
        service.date = draft.date
        service.notes = draft.notes.isEmpty ? nil : draft.notes
        service.client = client
        service.beforePhoto = draft.beforePhotoData
        service.afterPhoto = draft.afterPhotoData
        service.developerRatio = draft.developerRatio
        service.developer = draft.developer

        let developerAmount = ServiceCalculator.developerAmount(for: draft.selections, ratio: draft.developerRatio)
        service.developerAmountUsed = developerAmount

        var items: Set<FormulaItem> = []
        for selection in draft.selections {
            let item = FormulaItem(context: context)
            item.id = UUID()
            item.amountUsed = selection.amountValue
            item.ratioPart = selection.ratioPart
            item.product = selection.product
            item.cost = selection.cost
            item.service = service
            items.insert(item)
        }
        service.formulaItems = items
        service.totalCost = ServiceCalculator.totalCost(
            selections: draft.selections,
            developer: draft.developer,
            developerAmount: developerAmount
        )

        saveContext()
        reload()

        for selection in draft.selections {
            inventoryStore.adjustStock(for: selection.product, by: -selection.amountValue)
        }

        if let developer = draft.developer, developerAmount > 0 {
            inventoryStore.adjustStock(for: developer, by: -developerAmount)
        }
    }

    private func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
        }
    }
}
