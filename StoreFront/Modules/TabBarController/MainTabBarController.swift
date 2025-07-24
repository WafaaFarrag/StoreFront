//
//  MainTabBarController.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//
import UIKit

final class MainTabBarController: UITabBarController {
    
    private let centerButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        customizeTabBarAppearance()
        selectedIndex = 0
    }
 
    private func setupViewControllers() {
        viewControllers = [
            createHomeNavController(),
            createCartNavController()
        ]
    }
    
    private func createHomeNavController() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let homeVC = storyboard.instantiateViewController(
            withIdentifier: "HomeViewController"
        ) as? HomeViewController else {
            fatalError("Failed to instantiate HomeViewController")
        }
        
        let homeVM = AppDIContainer.shared.makeHomeViewModel()
        homeVC.configure(with: homeVM)
        
        let navController = UINavigationController(rootViewController: homeVC)
        navController.tabBarItem = UITabBarItem(
            title: "homeTab".localized(),
            image: UIImage(named: LayoutMetrics.TabBar.homeIcon),
            selectedImage: UIImage(named: LayoutMetrics.TabBar.homeSelectedIcon)
        )
        return navController
    }
    
    private func createCartNavController() -> UINavigationController {
        let cartVC = CartViewController()
        let navController = UINavigationController(rootViewController: cartVC)
        navController.tabBarItem = UITabBarItem(
            title: "cartTab".localized(),
            image: UIImage(named: LayoutMetrics.TabBar.cartIcon),
            selectedImage: UIImage(named: LayoutMetrics.TabBar.cartSelectedIcon)
        )
        return navController
    }

    private func customizeTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = LayoutMetrics.TabBar.backgroundColor
        
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }
        
        tabBar.tintColor = LayoutMetrics.TabBar.tintColor
        tabBar.unselectedItemTintColor = LayoutMetrics.TabBar.unselectedTintColor
        tabBar.layer.masksToBounds = true
    }
}
