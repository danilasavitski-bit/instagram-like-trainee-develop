//
//  HomeCoordinator.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 04/04/2024.
//

import UIKit
import SwiftUI

protocol HomeCoordinator: CoordinatorProtocol {
    func didPressDirect()
    func didPressProfile(userId: Int)
    func closeProfile()
}

final class HomePageCoordinator: HomeCoordinator {
    weak var parentCoordinator: MainCoordinator?
    private var jsonService: JsonService
    private var childCoordinators = [CoordinatorProtocol]()
    private var navigationController: UINavigationController
    private var controllers: [UIViewController] = []

    private var rootViewController: UIViewController {
        navigationController.viewControllers.first ?? UIViewController()
    }

    init(rootNavigationController: UINavigationController, jsonService: JsonService) {
        self.navigationController = rootNavigationController
        self.jsonService = jsonService
        self.controllers = [showHomeController()]
    }

    func start() {
        navigationController.setViewControllers(controllers, animated: true)
    }

    func didPressDirect() {
        let directViewController = DirectPageViewController(
            viewModel:
                DirectPageViewModel(
                    coordinator:
                        DirectPageCoordinator(
                            rootNavigationController:
                                navigationController,
                            jsonService: jsonService, parent: self),
                    jsonService: jsonService))
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(directViewController, animated: true)
    }

    func didPressProfile(userId: Int) {
        let profileViewModel = ProfileViewModel(coordinator: self, id: userId, jsonService: jsonService)
        let view = ProfileView(viewModel: profileViewModel)
        let hostingController = UIHostingController(rootView: view)
        navigationController.pushViewController(hostingController, animated: true)
        navigationController.isNavigationBarHidden = true
    }

    func closeProfile() {
        navigationController.popViewController(animated: true)
        navigationController.isNavigationBarHidden = false
    }

    private func showHomeController() -> UIViewController {
        let controller = HomePageViewController(
            viewModel: HomePageViewModel(
                coordinator: self,
                jsonService: jsonService
            )
        )
        return controller
    }
}
