//
//  AppCoordinator.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 04/04/2024.
//

import UIKit

final class AppCoordinator: CoordinatorProtocol {
    private var childCoordinators = [CoordinatorProtocol]()
    private var navigationController: UINavigationController
    private var jsonService: JsonService

    var rootViewController: UIViewController {
        self.navigationController
    }

    init(rootNavigationController: UINavigationController, jsonService: JsonService) {
        self.navigationController = rootNavigationController
        self.jsonService = jsonService
    }

    func start() {
        showMainFlow()
    }

    private func showMainFlow() {
        let mainCoordinator = MainCoordinator(rootTabBarController: UITabBarController(), jsonService: jsonService)
        childCoordinators.append(mainCoordinator)
        mainCoordinator.parentCoordinator = self
        mainCoordinator.start()
        navigationController.pushViewController(mainCoordinator.rootViewController, animated: true)
    }
}
