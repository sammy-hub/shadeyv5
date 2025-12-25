import Foundation

enum ClientRoute: Hashable {
    case detail(UUID)
    case service(UUID)
}
