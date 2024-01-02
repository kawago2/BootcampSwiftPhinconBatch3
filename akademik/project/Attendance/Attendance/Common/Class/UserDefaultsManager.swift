import UIKit

class UserDefaultsManager {

    // MARK: - Keys
    private struct Keys {
        static let isFirstInstall = "isFirstInstall"
    }

    // MARK: - Singleton
    static let shared = UserDefaultsManager()

    private init() {
        setDefaultValues()
    }

    // MARK: - Setters
    func setFirstInstall(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.isFirstInstall)
    }
    
    // MARK: - Getters
    func getFirstInstall() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.isFirstInstall)
    }
    

    // MARK: - Default Values
    private func setDefaultValues() {
        if UserDefaults.standard.object(forKey: Keys.isFirstInstall) == nil {
            setFirstInstall(false)
        }
        

    }
}
