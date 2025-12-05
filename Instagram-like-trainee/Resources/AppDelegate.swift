//
//  AppDelegate.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 20.03.24.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window =  UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        navigationController.navigationBar.isHidden = true
        window.rootViewController = navigationController
        self.window = window
        window.makeKeyAndVisible()
        coordinator = AppCoordinator(rootNavigationController: navigationController,networkService: NetworkService())
        coordinator?.start()
        return true
    }
}
