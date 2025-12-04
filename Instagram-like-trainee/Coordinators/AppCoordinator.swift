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
    private var networkService: NetworkService

    var rootViewController: UIViewController {
        self.navigationController
    }

    init(rootNavigationController: UINavigationController, networkService: NetworkService) {
        self.navigationController = rootNavigationController
        self.networkService = networkService
    }

    func start() {
        Task{
            try await networkService.fetchData()
            await MainActor.run{
                showMainFlow()
            }
        }
    }

    private func showMainFlow() {
        let mainCoordinator = MainCoordinator(rootTabBarController: UITabBarController(), networkService: networkService)
        childCoordinators.append(mainCoordinator)
        mainCoordinator.parentCoordinator = self
        mainCoordinator.start()
        navigationController.pushViewController(mainCoordinator.rootViewController, animated: true)
    }
}
