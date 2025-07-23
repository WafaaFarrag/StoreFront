//
//  MainTabBarController.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//
import UIKit

class MainTabBarController: UITabBarController {
    
    private let centerButton = UIButton()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewControllers()
        customizeTabBarAppearance()
        selectedIndex = 0

    }
 
    // MARK: - Setup Tabs
    private func setupViewControllers() {
        viewControllers = [
            createHomeNavController(),
            createNavController(for: CartViewController(), titleKey: "cartTab", imageName: "cartIcon", selectedImageName: "cartSelectedIcon"),
           
        ]
    }
    
    private func createNavController(for rootViewController: UIViewController,
                                     titleKey: String,
                                     imageName: String,
                                     selectedImageName: String) -> UINavigationController {
        
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem = UITabBarItem(
            title: titleKey.localized(),
            image: UIImage(named: imageName),
            selectedImage: UIImage(named: selectedImageName)
        )
        
        return navController
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
            image: UIImage(named: "homeIcon"),
            selectedImage: UIImage(named: "homeSelectedIcon")
        )
        
        return navController
    }

    // MARK: - TabBar Appearance
    private func customizeTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white

        tabBar.standardAppearance = appearance

        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        tabBar.tintColor = .redPrimary
        tabBar.unselectedItemTintColor = UIColor.lightGray
        tabBar.layer.masksToBounds = true
    }

}
