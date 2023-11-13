import UIKit

class TabBarViewController: UITabBarController {
    
    let dashboardViewController = DashboardViewController()
    let profileViewController = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUITabBarItems()
        configureTab()
        configureAppearance()
        setFirstFocus(index: 0)
    }
    
    func configureUITabBarItems() {
        let dashboardTabBarItem = UITabBarItem(title: "Dashboard", image: IconSystem.dashboard, tag: 0)
        let profileTabBarItem = UITabBarItem(title: "Profile", image: IconSystem.profile, tag: 0)
        
        dashboardViewController.tabBarItem = dashboardTabBarItem
        profileViewController.tabBarItem = profileTabBarItem
        
        viewControllers = [ dashboardViewController, profileViewController]
        
    }
    
    func configureAppearance() {
        let normalTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "MainColor") ?? UIColor.black]
        
        UITabBarItem.appearance().setTitleTextAttributes(normalTextAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedTextAttributes, for: .selected)
        UITabBar.appearance().tintColor = UIColor(named: "MainColor") ?? UIColor.black
        UITabBar.appearance().barTintColor = UIColor(named: "ThirdColor") ?? UIColor.white
        
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
