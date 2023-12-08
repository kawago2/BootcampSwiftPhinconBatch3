import UIKit

class UserDefaultsManager {

    // MARK: - Keys
    private struct Keys {
        static let isTransactionAlert = "isTransactionAlert"
        static let isInsightAlert = "isInsightAlert"
        static let isSortTransactionsAlert = "isSortTransactionsAlert"
    }

    // MARK: - Singleton
    static let shared = UserDefaultsManager()

    private init() {
        setDefaultValues()
    }

    // MARK: - Setters
    func setTransactionAlert(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.isTransactionAlert)
    }

    func setInsightAlert(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.isInsightAlert)
    }

    func setSortTransactionsAlert(_ value: Bool) {
        UserDefaults.standard.set(value, forKey: Keys.isSortTransactionsAlert)
    }

    // MARK: - Getters
    func getTransactionAlert() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.isTransactionAlert)
    }

    func getInsightAlert() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.isInsightAlert)
    }

    func getSortTransactionsAlert() -> Bool {
        return UserDefaults.standard.bool(forKey: Keys.isSortTransactionsAlert)
    }

    // MARK: - Default Values
    private func setDefaultValues() {
        if UserDefaults.standard.object(forKey: Keys.isTransactionAlert) == nil {
            setTransactionAlert(true)
        }
        if UserDefaults.standard.object(forKey: Keys.isInsightAlert) == nil {
            setInsightAlert(false)
        }
        if UserDefaults.standard.object(forKey: Keys.isSortTransactionsAlert) == nil {
            setSortTransactionsAlert(false)
        }
    }
}
