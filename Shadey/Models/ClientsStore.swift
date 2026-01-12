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
        service.developerRatio = 0
        service.developerAmountUsed = 0
        service.totalCost = 0

        var items: Set<FormulaItem> = []
        var formulas: Set<ServiceFormula> = []
        var totalCost: Double = 0

        for (index, formulaDraft) in draft.formulas.enumerated() {
            let formula = ServiceFormula(context: context)
            formula.id = UUID()
            formula.name = formulaDraft.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                ? "Formula \(index + 1)"
                : formulaDraft.name
            formula.sortOrder = Int16(index)
            formula.developerRatio = formulaDraft.developerRatio
            formula.developer = formulaDraft.developer

            let developerAmount = ServiceCalculator.developerAmount(
                for: formulaDraft.selections,
                ratio: formulaDraft.developerRatio
            )
            formula.developerAmountUsed = developerAmount

            var formulaItems: Set<FormulaItem> = []
            for selection in formulaDraft.selections {
                let item = FormulaItem(context: context)
                item.id = UUID()
                item.amountUsed = selection.amountValue
                item.ratioPart = selection.ratioPart
                item.product = selection.product
                item.cost = selection.cost
                item.service = service
                item.serviceFormula = formula
                formulaItems.insert(item)
                items.insert(item)
            }

            formula.formulaItems = formulaItems
            formula.totalCost = ServiceCalculator.totalCost(
                selections: formulaDraft.selections,
                developer: formulaDraft.developer,
                developerAmount: developerAmount
            )
            formula.service = service
            formulas.insert(formula)
            totalCost += formula.totalCost

            if index == 0 {
                service.developerRatio = formula.developerRatio
                service.developer = formula.developer
                service.developerAmountUsed = formula.developerAmountUsed
            }
        }

        service.formulaItems = items
        service.formulaGroups = formulas
        service.totalCost = totalCost

        saveContext()
        reload()

        for formula in draft.formulas {
            for selection in formula.selections {
                let deduction = FormulaDeductionCalculator.deductionAmount(for: selection)
                inventoryStore.adjustStock(for: selection.product, by: -deduction)
            }

            let developerAmount = ServiceCalculator.developerAmount(
                for: formula.selections,
                ratio: formula.developerRatio
            )
            if let developer = formula.developer, developerAmount > 0 {
                inventoryStore.adjustStock(for: developer, by: -developerAmount)
            }
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
