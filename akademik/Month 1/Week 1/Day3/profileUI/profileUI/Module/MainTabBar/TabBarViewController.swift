//
//  TabBarViewController.swift
//  profileUI
//
//  Created by Phincon on 30/10/23.
//

import UIKit

class TabBarViewController: UITabBarController {

    let homeViewController = SectionViewController()
    let profileViewController = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUITabBarItems()
        configureTab()
    }
    
    func configureUITabBarItems() {
     
        homeViewController.title = "Home"
        profileViewController.title = "Profile"
        
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image:IconSystem.home, tag: 0)
        profileViewController.tabBarItem = UITabBarItem(title: "Profile", image: IconSystem.profile, tag: 1)
        viewControllers = [homeViewController, profileViewController]
        
        // Customize appearance for tab bar items
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.blue], for: .selected)
    }
    
    func configureTab() {
        setViewControllers([homeViewController, profileViewController], animated: true)
    }
}
