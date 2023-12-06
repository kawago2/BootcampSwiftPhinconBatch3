import UIKit

class TabBarViewController: UITabBarController {
    
    let profileViewController = ProfileViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUITabBarItems()
        configureTab()
        configureAppearance()
        setFirstFocus(index: 0)
    }
    
    func configureUITabBarItems() {
        let profileTabBarItem = UITabBarItem(title: "Profile", image: CustomIcon.profile, tag: 0)
        
        profileViewController.tabBarItem = profileTabBarItem
        
        viewControllers = [profileViewController]
    }
    
    func configureAppearance() {
        let normalTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "Primary") ?? UIColor.black]
        let selectedTextAttributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor(named: "Primary") ?? UIColor.black]
        
        UITabBarItem.appearance().setTitleTextAttributes(normalTextAttributes, for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(selectedTextAttributes, for: .selected)
        
        let iconColor = UIColor(named: "Primary") ?? UIColor.black
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
