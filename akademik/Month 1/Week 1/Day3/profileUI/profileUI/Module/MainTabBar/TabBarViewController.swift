import UIKit

class TabBarViewController: UITabBarController {
    
    let homeViewController = HomeViewController()
    let historyViewController = HistoryViewController()
    let profileViewController = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUITabBarItems()
        configureTab()
        configureAppearance()
        setFirstFocus(index: 0)
    }
    
    func configureUITabBarItems() {
        let homeTabBarItem = UITabBarItem(title: "Home", image: Icons.home, tag: 0)
        let historyTabBarItem = UITabBarItem(title: "History", image: Icons.history, tag: 1)
        let profileTabBarItem = UITabBarItem(title: "Profile", image: Icons.profile, tag: 2)
        
        homeViewController.tabBarItem = homeTabBarItem
        historyViewController.tabBarItem = historyTabBarItem
        profileViewController.tabBarItem = profileTabBarItem
        
        viewControllers = [homeViewController, historyViewController, profileViewController]
    }
    
    func configureAppearance() {
        let normalTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "unselectColor") ?? UIColor.black]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "MainColor") ?? UIColor.black]
        
        UITabBarItem.appearance().setTitleTextAttributes(normalTextAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        let iconColor = UIColor(named: "MainColor") ?? UIColor.black
        UITabBar.appearance().tintColor = iconColor
        
        let bgColor = UIColor.white
        UITabBar.appearance().barTintColor = bgColor
        
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
    }
    
    func configureTab() {
        setViewControllers(viewControllers, animated: true)
    }
    
    func setFirstFocus(index: Int) {
        selectedIndex = index
    }
}
