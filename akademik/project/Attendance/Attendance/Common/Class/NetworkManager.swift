import Foundation
import Reachability

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() {} // Private initializer to enforce singleton pattern
    
    var isConnected: Bool {
        guard let reachability = try? Reachability() else {
            return false
        }
        return reachability.connection != .unavailable
    }
    
    func getStatus() -> Status {
        return isConnected ? .connected : .notConnected
    }
    
    enum Status {
        case connected, notConnected
    }
}
