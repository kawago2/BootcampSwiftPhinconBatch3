import UIKit

// MARK: - Enum
enum TabIndex: Int {
    case home = 0
    case graph = 1
    case chart = 2
    case profile = 3
}

class TabBarViewController: UITabBarController {
    
    // MARK: - Properties
    let homeViewController = ProfileViewController()
    let graphViewController = ProfileViewController()
    let chartViewController = InsightViewController()
    let profileViewController = ProfileViewController()
    
    private let tabBarHeight: CGFloat = 100
    private let tabBarCornerRadius: CGFloat = 30
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUITabBarItems()
        configureTab()
        configureAppearance()
        setFirstFocus(index: TabIndex.chart.rawValue)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setHeightBar(height: tabBarHeight)
    }
    
    
    // MARK: - Configuration
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
        tabBar.layer.cornerRadius = tabBarCornerRadius
        tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setHeightBar(height: Double) {
        
        var tabFrame = tabBar.frame
        tabFrame.size.height = height
        tabFrame.origin.y = view.frame.size.height - height
        tabBar.frame = tabFrame
        
    }
}

// MARK: - UITabBarControllerDelegate
extension TabBarViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let selectedIndex = tabBarController.viewControllers?.firstIndex(of: viewController) else { return }

        tabBar.tintColor = (selectedIndex == 0) ? UIColor.white : UIColor(named: "Primary")
        tabBar.backgroundColor = (selectedIndex == 0) ? UIColor(named: "Primary") : UIColor.white
        tabBar.unselectedItemTintColor = (selectedIndex == 0) ? UIColor.white : UIColor(named: "Primary")
    }
}
