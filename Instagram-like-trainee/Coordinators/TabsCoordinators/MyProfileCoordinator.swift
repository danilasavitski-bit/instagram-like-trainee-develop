//
//  MyProfileCoordinator.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 04/04/2024.
//

import UIKit
//MARK: - Protocol
protocol MyProfileCoordinatorProtocol: CoordinatorProtocol {} 
//MARK: - MyProfileCoordinator
class MyProfileCoordinator: MyProfileCoordinatorProtocol {
    weak var parentCoordinator: MainCoordinator?
    private var childCoordinators = [CoordinatorProtocol]()
    private var navigationController: UINavigationController

    var rootViewController: UIViewController {
        navigationController
    }

    init(rootNavigationController: UINavigationController) {
        self.navigationController = rootNavigationController
    }

    func start() {}
}
