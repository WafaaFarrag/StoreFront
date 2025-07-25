//
//  AppDelegate.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import UIKit
import SkeletonView
import Kingfisher

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        setupRootViewController()
        
        
        if let font = UIFont(name: "Nunito-Regular", size: 12) {
            let attributes: [NSAttributedString.Key: Any] = [
                .font: font,
                .foregroundColor: UIColor.black
            ]

            UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .normal)
            UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .selected)
        }

        setupSkeletonAppearance()
        configureKingfisherCache()
        saveBase()
        return true
    }
    
    private func saveBase(){
        if KeychainManager.load(forKey: "api_base_url") == nil {
            KeychainManager.save("https://fakestoreapi.com", forKey: "api_base_url")
        }
    }
    
    private func setupSkeletonAppearance() {
        SkeletonAppearance.default.tintColor = UIColor.lightGray.withAlphaComponent(0.3)
        SkeletonAppearance.default.gradient = SkeletonGradient(
            baseColor: UIColor.systemGray5,
            secondaryColor: UIColor.systemGray4
        )
        SkeletonAppearance.default.multilineHeight = 12
    }
    
    private func configureKingfisherCache() {
           let cache = ImageCache.default
           cache.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
           cache.diskStorage.config.sizeLimit = 200 * 1024 * 1024
           cache.memoryStorage.config.expiration = .days(7)
           cache.diskStorage.config.expiration = .days(30)
       }

    private func setupRootViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let mainTabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController else {
            fatalError("Could not instantiate MainTabBarController from Storyboard.")
        }

        UIView.transition(with: window!,
                          duration: 0.5,
                          options: .transitionCrossDissolve,
                          animations: {
                              self.window?.rootViewController = mainTabBarController
                          },
                          completion: nil)
    }
    
}

