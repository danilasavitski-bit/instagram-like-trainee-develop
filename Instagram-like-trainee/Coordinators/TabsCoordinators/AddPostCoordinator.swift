//
//  AddPostCoordinator.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 04/04/2024.
//

import UIKit
//MARK: - Protocol
protocol AddPostCoordinatorProtocol: CoordinatorProtocol {
    func start()
    func openEditPhotos()
    func close()
    func openCamera()
}
//MARK: - AddPstCoordinator
class AddPostCoordinator: AddPostCoordinatorProtocol {
    weak var parentCoordinator: MainCoordinator?
    private var childCoordinators = [CoordinatorProtocol]()
    private var navigationController: UINavigationController
    private var networkService: NetworkService
    private var controllers: [UIViewController] = []
    private var rootViewController: UIViewController {
        navigationController.viewControllers.first ?? UIViewController()
    }

    init(rootNavigationController: UINavigationController, networkService: NetworkService, parent: MainCoordinator) {
        self.parentCoordinator = parent
        self.navigationController = rootNavigationController
        self.networkService = networkService
    }

    func start() {
        let viewModel = CreatePostViewModel()
        let applicationViewController = CreatePostViewController(viewModel: viewModel)
        navigationController.setViewControllers([applicationViewController], animated: true)
    }
    
    func openEditPhotos() {
        
    }
    
    func close() {
        
    }
    
    func openCamera() {
        
    }
    
    
}
