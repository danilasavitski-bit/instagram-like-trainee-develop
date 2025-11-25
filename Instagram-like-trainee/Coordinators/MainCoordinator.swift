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
    private var jsonService: JsonService

    public var rootViewController: UIViewController {
        return self.tabBarController
    }

    init(rootTabBarController: UITabBarController, jsonService: JsonService) {
        self.tabBarController = rootTabBarController
        self.jsonService = jsonService
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
        let navigationViewController = UINavigationController() // тут создается отдельно navigationControlller, а в остальных создается в самой функции configureTabBarItem
        let homeCoordinator = HomePageCoordinator(
            rootNavigationController: navigationViewController,
            jsonService: jsonService
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
        let searchViewController = SearchViewController()
        searchViewController.view.backgroundColor = .systemCyan
        return configureTabBarItem(
            viewController: UINavigationController(rootViewController: searchViewController),
            image: .magnifyingglassCircle,
            selectedImage: .magnifyingglassCircleFill)
    }

    private func prepareAddPostView() -> UINavigationController {
        let applicationViewController = SearchViewController() // почему используется SearchViewController если есть отдельный для добавления поста
        applicationViewController.view.backgroundColor = .systemGray
        return configureTabBarItem(
            viewController: UINavigationController(rootViewController: applicationViewController),
            image: .plusApp,
            selectedImage: .plusAppFill)
    }

    private func prepareReelsView() -> UINavigationController {
        let reelsViewController = MyProfileViewController() // почему используется MyProfileViewController если есть отдельный для рилсов
        reelsViewController.view.backgroundColor = .systemGreen
        return configureTabBarItem(
            viewController: UINavigationController(rootViewController: reelsViewController),
            image: .playRectangle,
            selectedImage: .playRectangleFill)
    }

    private func prepareMyProfileView() -> UINavigationController {
        let myProfileViewController = MyProfileViewController()
        myProfileViewController.view.backgroundColor = .systemPink
        return configureTabBarItem(
            viewController: UINavigationController(rootViewController: myProfileViewController),
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
