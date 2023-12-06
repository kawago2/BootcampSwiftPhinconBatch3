import UIKit

class TabBarViewController: UITabBarController {
    
    let homeViewController = ProfileViewController()
    let graphViewController = ProfileViewController()
    let chartViewController = ProfileViewController()
    let profileViewController = ProfileViewController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUITabBarItems()
        configureTab()
        configureAppearance()
        setFirstFocus(index: 3)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setHeightBar(height: 100)
    }
    
    func configureUITabBarItems() {
        self.delegate = self
        let homeTabBarItem = UITabBarItem(title: "", image: CustomIcon.home, selectedImage: CustomIcon.selectedHome)
        let graphTabBarItem = UITabBarItem(title: "", image: CustomIcon.graph, selectedImage: CustomIcon.selectedGraph)
        let chartTabBarItem = UITabBarItem(title: "", image: CustomIcon.chart, selectedImage: CustomIcon.selectedChart)
        let profileTabBarItem = UITabBarItem(title: "", image: CustomIcon.profile, selectedImage: CustomIcon.selectedProfile)
        
        
        homeViewController.tabBarItem = homeTabBarItem
        graphViewController.tabBarItem = graphTabBarItem
        chartViewController.tabBarItem = chartTabBarItem
        profileViewController.tabBarItem = profileTabBarItem
        viewControllers = [homeViewController, graphViewController, chartViewController, profileViewController]
    }
    
    func configureAppearance() {
        tabBar.tintColor = UIColor(named: "Primary")
        tabBar.barTintColor = UIColor.white
        tabBar.backgroundColor = UIColor.white
        tabBar.unselectedItemTintColor = UIColor(named: "Primary")
        setupRoundedCorner()
       
    }
    
    func configureTab() {
        setViewControllers(viewControllers, animated: true)
    }
    
    func setFirstFocus(index: Int) {
        selectedIndex = index
        guard let viewControllers = viewControllers, selectedIndex < viewControllers.count else {
            return
        }
        
        if let viewController = self.viewControllers?[selectedIndex] {
            tabBarController(self, didSelect: viewController)
        }
    }
    
    private func setupRoundedCorner() {
        tabBar.layer.masksToBounds = true
        tabBar.isTranslucent = true
        tabBar.layer.cornerRadius = 30
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setHeightBar(height: Double) {
        
        var tabFrame = tabBar.frame
        tabFrame.size.height = height
        tabFrame.origin.y = view.frame.size.height - height
        tabBar.frame = tabFrame
        
    }
}

extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) {
            if selectedIndex == 0 {
                tabBar.tintColor = UIColor.white
                tabBar.unselectedItemTintColor = UIColor.white
                tabBar.backgroundColor =  UIColor(named: "Primary")
            } else {
                tabBar.tintColor = UIColor(named: "Primary")
                tabBar.backgroundColor  = UIColor.white
                tabBar.unselectedItemTintColor = UIColor(named: "Primary")
            }
        }
    }
}
