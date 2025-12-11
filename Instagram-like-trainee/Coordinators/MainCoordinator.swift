//
//  Coordinator.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 03/04/2024.
//

import UIKit

final class MainCoordinator: CoordinatorProtocol {
    weak var parentCoordinator: AppCoordinator?
    private var childCoordinators = [CoordinatorProtocol]()
    private var tabBarController: UITabBarController
    private var networkService: NetworkService

    public var rootViewController: UIViewController {
        return self.tabBarController
    }

    init(rootTabBarController: UITabBarController, networkService: NetworkService) {
        self.tabBarController = rootTabBarController
        self.networkService = networkService
        
    }

    func start() {
        tabBarController.setViewControllers([
            prepareHomeView(),
            prepareSearchView(),
            prepareAddPostView(),
            prepareReelsView(),
            prepareMyProfileView()
        ], animated: true) // хз насколько тут нужен animated если этого не видно
        setTabBarAppearance(tabBarController)
    }

    private func prepareHomeView() -> UINavigationController {
        let navigationViewController = UINavigationController()
        let homeCoordinator = HomePageCoordinator(
            rootNavigationController: navigationViewController,
            networkService: networkService
        )
        homeCoordinator.parentCoordinator = self
        homeCoordinator.start()

        childCoordinators.append(homeCoordinator)
        return configureTabBarItem(
            viewController: navigationViewController,
            image: .house,
            selectedImage: .houseFill)
    }

    private func prepareSearchView() -> UINavigationController {
        let navigationViewController = UINavigationController()

        let searchCoordinator = SearchCoordinator(
            rootNavigationController: navigationViewController,
            networkService: networkService
        )
        
        searchCoordinator.parentCoordinator = self
        childCoordinators.append(searchCoordinator)
        
        searchCoordinator.start()
        return configureTabBarItem(
            viewController: navigationViewController,
            image: .magnifyingglassCircle,
            selectedImage: .magnifyingglassCircleFill)
    }

    private func prepareAddPostView() -> UINavigationController {
        let navigationViewController = UINavigationController()

        let addPostCoordinator = AddPostCoordinator(
            rootNavigationController: navigationViewController,
            networkService: networkService,
            parent: self
        )
        
        addPostCoordinator.parentCoordinator = self
        childCoordinators.append(addPostCoordinator)
        
        addPostCoordinator.start()
        return configureTabBarItem(
            viewController: navigationViewController,
            image: .plusApp,
            selectedImage: .plusAppFill)
    }

    private func prepareReelsView() -> UINavigationController {
        let reelsViewController = ReelsViewController() // почему используется MyProfileViewController если есть отдельный для рилсов
        reelsViewController.view.backgroundColor = .systemGreen
        return configureTabBarItem(
            viewController: UINavigationController(rootViewController: reelsViewController),
            image: .playRectangle,
            selectedImage: .playRectangleFill)
    }

    private func prepareMyProfileView() -> UINavigationController {
    
        let navigationController = UINavigationController()
        let myProfileCoordinator = MyProfileCoordinator (
            rootNavigationController: navigationController,
            networkService: networkService
           )
    
        childCoordinators.append(myProfileCoordinator)
        myProfileCoordinator.parentCoordinator = self
        myProfileCoordinator.start()
        
        return configureTabBarItem(
            viewController: navigationController ,
            image: .personCropCircle,
            selectedImage: .personCropCircleFill)
    }

    private func configureTabBarItem(
        viewController: UINavigationController,
        image: UIImage?,
        selectedImage: UIImage?
    ) -> UINavigationController {
        viewController.tabBarItem.image = image
        viewController.tabBarItem.selectedImage = selectedImage
        return viewController
    }

    private func setTabBarAppearance(_ tabBar: UITabBarController) {
        tabBar.selectedIndex = 0
        tabBar.view.tintColor = .black
        tabBar.view.backgroundColor = .white
        tabBar.tabBar.unselectedItemTintColor = .black
    }
}
