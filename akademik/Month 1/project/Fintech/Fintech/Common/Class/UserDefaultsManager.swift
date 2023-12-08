import Foundation

class UserDefaultsManager {
    
    // MARK: - Keys
    
    private struct Keys {
        static let username = "username"
        // Add more keys as needed
    }

    // MARK: - Singleton
    
    static let shared = UserDefaultsManager()
    
    private init() {
        // Private initializer to enforce singleton pattern
    }
    
    // MARK: - Username
    
    var username: String? {
        get {
            return UserDefaults.standard.string(forKey: Keys.username)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.username)
        }
    }

    // MARK: - Add more methods and properties for other user defaults as needed
}
