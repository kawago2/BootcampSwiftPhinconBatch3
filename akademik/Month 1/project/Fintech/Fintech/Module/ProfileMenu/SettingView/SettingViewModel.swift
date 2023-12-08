import UIKit

enum Section: Int {
    case general = 0
    case security = 1
}

struct CellContent {
    var name: String
    var description: String?
}


class SettingViewModel {
    
    let titleNavigationBar = "Settings"
}
