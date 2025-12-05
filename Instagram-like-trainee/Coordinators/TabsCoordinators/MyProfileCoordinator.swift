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
    func didPressSettings()
    func didPressCloseSettings()
}
//MARK: - MyProfileCoordinator
class MyProfileCoordinator: MyProfileCoordinatorProtocol {
    
    weak var parentCoordinator: MainCoordinator?
    private var networkService: NetworkService
    private var childCoordinators = [CoordinatorProtocol]()
    private var navigationController: UINavigationController
    private var controllers: [UIViewController] = []

    var rootViewController: UIViewController {
        navigationController.viewControllers.first ?? UIViewController()
    }

    init(rootNavigationController: UINavigationController, networkService: NetworkService) {
        self.navigationController = rootNavigationController
        self.networkService = networkService
        self.controllers = [showHomeController()]
    }

    func start() {
        navigationController.setViewControllers(controllers, animated: true)
        navigationController.navigationBar.isHidden = true
    }
    func didPressSettings() {
        let viewModel = SettingsViewModel(coordinator: self)
        let view = SettingsView(viewModel: viewModel)
        let hostingController = UIHostingController(rootView: view)
        navigationController.pushViewController(hostingController, animated: true)
    }
    func didPressCloseSettings() {
        navigationController.popViewController(animated: true)
    }
    private func showHomeController() -> UIViewController {
        let currentUserId = networkService.currentUser?.id
        let profileViewModel = MyProfileViewModel(coordinator: self , networkService: networkService, id: currentUserId ?? 0)
        let view = MyProfileView(viewModel: profileViewModel)
        let hostingController = UIHostingController(rootView: view)
        return hostingController
    }
//    private func getCurrentUserId() -> Int? {
//        let jsonPath = Bundle.main.path(forResource: "users", ofType: "json")
//        let usersData = (
//            jsonService.fetchFromJson(
//                objectType: [User](),
//                filePath: jsonPath ?? ""
//            )
//        )
//        switch usersData {
//        case .success(let users):
//            return users.last!.id
//        case .failure(let failure):
//            print(failure.localizedDescription)
//            return nil
//        }
//    }
}
