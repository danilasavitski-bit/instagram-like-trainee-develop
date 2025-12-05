//
//  HomeCoordinator.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 04/04/2024.
//

import UIKit
import SwiftUI
//MARK: - Protocol
protocol HomeCoordinator: CoordinatorProtocol {
    func didPressDirect()
    func didPressProfile(userId: Int)
    func closeProfile()
}
//MARK: - HomePageCoordinator
final class HomePageCoordinator: HomeCoordinator {
    weak var parentCoordinator: MainCoordinator?
    private var networkService: NetworkService
    private var childCoordinators = [CoordinatorProtocol]()
    private var navigationController: UINavigationController
    private var controllers: [UIViewController] = []

    private var rootViewController: UIViewController {
        navigationController.viewControllers.first ?? UIViewController()
    }

    init(rootNavigationController: UINavigationController, networkService: NetworkService) {
        self.navigationController = rootNavigationController
        self.networkService = networkService
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
                                networkService: networkService, parent: self),
                    networkService: networkService))
        navigationController.setNavigationBarHidden(false, animated: true)
        navigationController.pushViewController(directViewController, animated: true)
    }

    func didPressProfile(userId: Int) {
        let profileViewModel = ProfileViewModel(coordinator: self, id: userId, networkService: networkService)
        let view = ProfileView(viewModel: profileViewModel)
        let hostingController = UIHostingController(rootView: view)
        
        navigationController.pushViewController(hostingController, animated: true)
        navigationController.isNavigationBarHidden = true
    }

    func closeProfile() {
        navigationController.popViewController(animated: true)
        navigationController.isNavigationBarHidden = true
    }

    private func showHomeController() -> UIViewController {
        let controller = HomePageViewController(
            viewModel: HomePageViewModel(
                coordinator: self,
                networkService: networkService
            )
        )
        return controller
    }
}
