import UIKit

class UserDefaultsManager {

    // MARK: - Keys
    private struct Keys {
        static let isFirstInstall = "isFirstInstall"
        static let isLoginTapped = "isLoginTapped"
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
    
    func setLoginTapped(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.isLoginTapped)
    }
    
    // MARK: - Getters
    func getFirstInstall() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.isFirstInstall)
    }
    
    func getLoginTapped() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.isLoginTapped)
    }

    // MARK: - Default Values
    private func setDefaultValues() {
        if UserDefaults.standard.object(forKey: Keys.isFirstInstall) == nil {
            setFirstInstall(false)
        }
        
        if UserDefaults.standard.object(forKey: Keys.isLoginTapped) == nil {
            setLoginTapped(false)
        }

    }
}
