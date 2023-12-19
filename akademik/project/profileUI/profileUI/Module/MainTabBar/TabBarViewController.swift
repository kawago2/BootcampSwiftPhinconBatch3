import UIKit

class TabBarViewController: UITabBarController {
    
    let dashboardViewController = DashboardViewController()
    let profileViewController = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUITabBarItems()
        configureTab()
        setFirstFocus(index: 0)
    }
    
    func configureUITabBarItems() {
        // Create separate UITabBarItem objects for each view controller
        let dashboardTabBarItem = UITabBarItem(title: "Dashboard", image: IconSystem.dashboard, tag: 0)
        let profileTabBarItem = UITabBarItem(title: "Profile", image: IconSystem.profile, tag: 0)
        
        dashboardViewController.tabBarItem = dashboardTabBarItem
        profileViewController.tabBarItem = profileTabBarItem
        
        viewControllers = [ dashboardViewController, profileViewController]
        
        // Customize appearance for tab bar items
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor(named: "MainColor") ?? UIColor.black], for: .selected)
        UITabBar.appearance().tintColor = UIColor(named: "MainColor") ?? UIColor.black
        UITabBar.appearance().barTintColor = UIColor(named: "ThirdColor") ?? UIColor.white
        
        // Hide the separator and make the background clear
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        
    }
    
    func configureTab() {
        setViewControllers([dashboardViewController, profileViewController], animated: true)
    }
    func setFirstFocus(index: Int){
        selectedIndex = index
    }
}
