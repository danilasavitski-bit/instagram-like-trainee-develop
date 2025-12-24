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
    func openEditPost(with image: Media)
    func closeTakePhoto()
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
        let applicationViewController = AddPostViewController(viewModel: viewModel)
        navigationController.navigationBar.tintColor = .systemBlue
        navigationController.setViewControllers([applicationViewController], animated: true)
    }
    
    func closeTakePhoto() {
        navigationController.navigationBar.isHidden = false
        navigationController.popViewController(animated: true)
    }
    
    func closeEditPhoto() {
        navigationController.navigationBar.isHidden = true
        navigationController.popViewController(animated: true)
    }
    
    func openEditPost(with image: Media){
        let viewModel = EditPostViewModel(media: image, networkService: networkService, coordinator: self)
        viewModel.populateWithData(from: viewModel.media)
        let hostingController = UIHostingController(rootView: EditPostView(viewModel: viewModel))
        navigationController.navigationBar.isHidden = true
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
        navigationController.navigationBar.isHidden = false
        navigationController.popToRootViewController(animated: true)
    }
    
}
