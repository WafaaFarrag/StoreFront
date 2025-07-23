//
//  AppCoordinator.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import Foundation
import UIKit

class AppCoordinator {
    private let window: UIWindow
    private var navigationController: UINavigationController?

    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        let viewModel = AppDIContainer.shared.makeHomeViewModel()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController else {
            fatalError("Could not instantiate HomeViewController from Storyboard.")
        }
        
        viewController.configure(with: viewModel) 

        let navController = UINavigationController(rootViewController: viewController)
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.navigationController = navController
    }
}
