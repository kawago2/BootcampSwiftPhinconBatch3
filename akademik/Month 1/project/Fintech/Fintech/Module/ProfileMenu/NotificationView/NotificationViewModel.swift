import UIKit

class NotificationViewModel {
    
    let titleNavigationBar = "Notifications"
    
    func switchTransactionTapped(isOn: Bool) {
        UserDefaultsManager.shared.setTransactionAlert(isOn)
    }
    
    func switchInsightTapped(isOn: Bool) {
        UserDefaultsManager.shared.setInsightAlert(isOn)
    }
    
    func switchSortTransactionsTapped(isOn: Bool) {
        UserDefaultsManager.shared.setSortTransactionsAlert(isOn)
    }
}
