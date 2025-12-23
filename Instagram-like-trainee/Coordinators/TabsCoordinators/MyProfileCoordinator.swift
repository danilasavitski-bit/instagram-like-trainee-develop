//
//  MyProfileCoordinator.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 04/04/2024.
//

import UIKit
import SwiftUI
//MARK: - Protocol
protocol MyProfileCoordinatorProtocol: CoordinatorProtocol {
    func openSettings()
    func closeSettings()
}
enum ControllerError: Error {
    case unknown
}
//MARK: - MyProfileCoordinator
class MyProfileCoordinator: MyProfileCoordinatorProtocol {
    
    weak var parentCoordinator: MainCoordinator?
    private var networkService: NetworkService
    private var childCoordinators = [CoordinatorProtocol]()
    private var navigationController: UINavigationController
    private var controllers: [UIViewController] = []

    init(rootNavigationController: UINavigationController, networkService: NetworkService) {
        self.navigationController = rootNavigationController
        self.networkService = networkService
        self.controllers = [showHomeController()]
    }

    func start() {
        navigationController.setViewControllers(controllers, animated: true)
        navigationController.navigationBar.isHidden = true
    }
    func openSettings() {
        let viewModel = SettingsViewModel(coordinator: self)
        let view = SettingsView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        navigationController.pushViewController(hostingController, animated: true)
    }
    func closeSettings() {
        navigationController.popViewController(animated: true)
    }
    
    func getRootViewController() throws -> UIViewController {
        guard let controller = navigationController.viewControllers.first else {
            throw ControllerError.unknown
        }
        return controller
    }
    
    private func showHomeController() -> UIViewController {
        let currentUserId = networkService.currentUser?.id
        let profileViewModel = MyProfileViewModel(coordinator: self , networkService: networkService, id: currentUserId ?? 0)
        let view = MyProfileView(viewModel: profileViewModel)
        let hostingController = UIHostingController(rootView: view)
        return hostingController
    }
    
}
