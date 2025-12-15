//
//  AddPostCoordinator.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 04/04/2024.
//

import UIKit
import SwiftUI
//MARK: - Protocol
protocol AddPostCoordinatorProtocol: CoordinatorProtocol {
    func start()
    func openEditPost(with image: UIImage)
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
        let viewModel = CreatePostViewModel(coordinator: self)
        let applicationViewController = CreatePostViewController(viewModel: viewModel)
        navigationController.navigationBar.tintColor = .systemBlue
        navigationController.setViewControllers([applicationViewController], animated: true)
    }
    
    func close() {
        navigationController.navigationBar.isHidden = false
        navigationController.popViewController(animated: true)
    }
    
    func openEditPost(with image: UIImage){
        let viewModel = EditPostViewModel(image: image, networkService: networkService, coordinator: self)
        let hostingController = UIHostingController(rootView: EditPostView(viewModel: viewModel))
        navigationController.navigationBar.isHidden = false
        hostingController.hidesBottomBarWhenPushed = true
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    func openCamera() {
        let viewModel = TakePhotoViewModel(coordinator: self)
        let hostingController = UIHostingController(rootView: TakePhotoView(viewModel: viewModel))
        hostingController.hidesBottomBarWhenPushed = true
        navigationController.navigationBar.isHidden = true
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    func openRootScreen() {
        
        navigationController.popToRootViewController(animated: true)
    }
    
}
