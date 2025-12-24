//
//  SearchCoordinator.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 04/04/2024.
//

import UIKit
import SwiftUI
//MARK: - Protocol
protocol SearchCoordinatorProtocol: CoordinatorProtocol {
    func openProfile(userId: Int)
}
//MARK: - SearchCoordinator
class SearchCoordinator: SearchCoordinatorProtocol, HomeCoordinator {
    
    weak var parentCoordinator: MainCoordinator?
    
    var rootViewController: UIViewController {
        navigationController
    }

    private var networkService: NetworkService
    private var childCoordinators = [CoordinatorProtocol]()
    private var navigationController: UINavigationController
    private var controllers: [UIViewController] = []

    init(rootNavigationController: UINavigationController, networkService: NetworkService) {
        self.navigationController = rootNavigationController
        self.networkService = networkService
        self.controllers = [showHomeController()]
    }
    private func showHomeController() -> UIViewController {
        let controller = SearchViewController(
            viewModel: SearchViewModel(
                coordinator: self,
                networkService: networkService
            )
        )
        return controller
    }
    func openProfile(userId: Int) {
        let profileViewModel = ProfileViewModel(coordinator: self, id: userId, networkService: networkService)
        let view = ProfileView(viewModel: profileViewModel)
        let hostingController = UIHostingController(rootView: view)
        hostingController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(hostingController, animated: true)
        
    }

    func closePage() {
        navigationController.popViewController(animated: true)
    }
    func start() {
        navigationController.setViewControllers(controllers, animated: true)
    }
}
