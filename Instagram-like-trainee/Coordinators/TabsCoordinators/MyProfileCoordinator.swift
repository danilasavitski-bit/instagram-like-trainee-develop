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
}
//MARK: - MyProfileCoordinator
class MyProfileCoordinator: MyProfileCoordinatorProtocol {
    
    weak var parentCoordinator: MainCoordinator?
    private var jsonService: JsonService
    private var childCoordinators = [CoordinatorProtocol]()
    private var navigationController: UINavigationController
    private var controllers: [UIViewController] = []

    var rootViewController: UIViewController {
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
    private func showHomeController() -> UIViewController {
        let currentUserId = getCurrentUserId()
        let profileViewModel = MyProfileViewModel(coordinator: self , jsonService: jsonService, id: currentUserId ?? 0)
        let view = ProfileView(viewModel: profileViewModel)
        let hostingController = UIHostingController(rootView: view)
        
//        navigationController.pushViewController(hostingController, animated: true)
//        navigationController.isNavigationBarHidden = true
        return hostingController
    }
    private func getCurrentUserId() -> Int? {
        let jsonPath = Bundle.main.path(forResource: "users", ofType: "json")
        let usersData = (
            jsonService.fetchFromJson(
                objectType: [User](),
                filePath: jsonPath ?? ""
            )
        )
        switch usersData {
        case .success(let users):
            return users.last!.id
        case .failure(let failure):
            print(failure.localizedDescription)
            return nil
        }
    }
}
