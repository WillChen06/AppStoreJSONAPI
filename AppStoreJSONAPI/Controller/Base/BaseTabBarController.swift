//
//  BaseTabBarController.swift
//  AppStoreJSONAPI
//
//  Created by WillChen on 2022/11/5.
//

import UIKit

class BaseTabBarController: UITabBarController {
    enum TabIcon: String {
        case today = "doc.text.image"
        case apps = "square.stack.3d.up.fill"
        case search = "magnifyingglass"
    }
        
    override func viewDidLoad() {        
        viewControllers = [
            createNavController(viewController: AppsPageController(), title: "Apps", icon: .apps),
            createNavController(viewController: UIViewController(), title: "Today", icon: .today),
            createNavController(viewController: AppsSearchViewController(), title: "Search", icon: .search)
        ]
    }
    
    private func createNavController(viewController: UIViewController, title: String, icon: TabIcon) -> UIViewController {
        let navController = UINavigationController(rootViewController: viewController)
        navController.navigationBar.prefersLargeTitles = true
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = .white
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: icon.rawValue)
        return navController
    }
}
