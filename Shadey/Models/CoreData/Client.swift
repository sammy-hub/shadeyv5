import CoreData

@objc(Client)
public final class Client: NSManagedObject {
    public var initials: String {
        let components = name.split(separator: " ")
        let letters = components.prefix(2).compactMap { $0.first }
        return letters.map(String.init).joined().uppercased()
    }

    public var sortedServices: [Service] {
        let set = services ?? []
        return set.sorted { $0.date > $1.date }
    }
}

extension Client {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Client> {
        NSFetchRequest<Client>(entityName: "Client")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var notes: String?
    @NSManaged public var services: Set<Service>?
}
