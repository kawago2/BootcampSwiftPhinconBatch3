import UIKit

class TabBarViewController: UITabBarController {

    // MARK: - View Controllers
    
    let homeViewController = HomeViewController()
    let historyViewController = HistoryViewController()
    let timesheetViewController = TimesheetViewController()
    let profileViewController = ProfileViewController()

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUITabBarItems()
        configureTab()
        configureAppearance()
        setFirstFocus(index: 0)
    }

    // MARK: - Configuration

    func configureUITabBarItems() {
        let homeTabBarItem = UITabBarItem(title: "Home", image: Icons.home, tag: 0)
        let historyTabBarItem = UITabBarItem(title: "History", image: Icons.history, tag: 1)
        let timesheetTabBarItem = UITabBarItem(title: "Timesheet", image: Icons.timesheet, tag: 2)
        let profileTabBarItem = UITabBarItem(title: "Profile", image: Icons.profile, tag: 3)

        homeViewController.tabBarItem = homeTabBarItem
        historyViewController.tabBarItem = historyTabBarItem
        timesheetViewController.tabBarItem = timesheetTabBarItem
        profileViewController.tabBarItem = profileTabBarItem

        viewControllers = [homeViewController, historyViewController, timesheetViewController, profileViewController]
    }

    func configureAppearance() {
        // Text Attributes
        let normalTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "unselectColor") ?? UIColor.black]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "MainColor") ?? UIColor.black]

        UITabBarItem.appearance().setTitleTextAttributes(normalTextAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedTextAttributes, for: .selected)

        // Icon Color
        let iconColor = UIColor(named: "MainColor") ?? UIColor.black
        UITabBar.appearance().tintColor = iconColor

        // Background Color
        let bgColor = UIColor.white
        UITabBar.appearance().barTintColor = bgColor

        // Remove Background and Shadow Images
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
    }

    func configureTab() {
        setViewControllers(viewControllers, animated: true)
    }

    // MARK: - Helper
    
    func setFirstFocus(index: Int) {
        selectedIndex = index
    }
}
