import UIKit

class TabBarViewController: UITabBarController {
    
    let dashboardViewController = SectionViewController()
    let homeViewController = HomeViewController()
    let profileViewController = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUITabBarItems()
        configureTab()
        
        setFirstFocus(index: 1)
    }
    
    func configureUITabBarItems() {
        // Create separate UITabBarItem objects for each view controller
        let dashboardTabBarItem = UITabBarItem(title: "Dashboard", image: IconSystem.dashboard, tag: 0)
        let homeTabBarItem = UITabBarItem(title: "Home", image: IconSystem.home, tag: 1)
        let profileTabBarItem = UITabBarItem(title: "Profile", image: IconSystem.profile, tag: 2)
        
        dashboardViewController.tabBarItem = dashboardTabBarItem
        homeViewController.tabBarItem = homeTabBarItem
        profileViewController.tabBarItem = profileTabBarItem
        
        viewControllers = [dashboardViewController, homeViewController, profileViewController]
        
        // Customize appearance for tab bar items
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named: "MainColor") ?? UIColor.black], for: .selected)
        UITabBar.appearance().tintColor = UIColor(named: "MainColor") ?? UIColor.black
        
    }
    
    func configureTab() {
        setViewControllers([dashboardViewController, homeViewController, profileViewController], animated: true)
    }
    func setFirstFocus(index: Int){
        selectedIndex = index
    }
}
