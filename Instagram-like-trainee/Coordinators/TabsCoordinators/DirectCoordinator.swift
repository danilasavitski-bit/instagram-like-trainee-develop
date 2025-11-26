//
//  DirectCoordinator.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 22.04.24.
//

import UIKit
//MARK: - Protocols
protocol DirectCoordinator: CoordinatorProtocol {
    func openDialogPressed(_ id: Int)
}
//MARK: - DirectPageCoordinator
final class DirectPageCoordinator: DirectCoordinator {
    private var parentCoordinator: HomeCoordinator
    private var jsonService: JsonService
    private var childCoordinators = [CoordinatorProtocol]()
    private var navigationController: UINavigationController
    private var controllers: [UIViewController] = []
    private var rootViewController: UIViewController {
        navigationController.viewControllers.first ?? UIViewController()
    }

    init(rootNavigationController: UINavigationController, jsonService: JsonService, parent: HomeCoordinator) {
        self.parentCoordinator = parent
        self.navigationController = rootNavigationController
        self.jsonService = jsonService
    }

    func start() {
        navigationController.setViewControllers(controllers, animated: true)
    }

    func openDialogPressed(_ id: Int) {
        let dialogVC = DialogViewController(id: id, coordinator: parentCoordinator)
            navigationController.pushViewController(dialogVC, animated: true)
        }
    }
