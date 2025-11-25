//
//  DialogViewController.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 22.04.24.
//

import UIKit

final class DialogViewController: UIViewController {

    private var conversationView: ConversationView?
    private var coordinator: HomeCoordinator?
    private var customView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 44))
    private var dialogUserProfileImage = UIImageView()
    var id: Int

    init(id: Int, coordinator: HomeCoordinator) {
        self.id = id
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        guard let coordinator = coordinator else { return }
        conversationView = ConversationView(viewModel: ConversationView.ViewModel(id: id), coordinator: coordinator)
        conversationView?.injectIn(controller: self)
        setUpNavigationBarButtons()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    private func setUpNavigationBarButtons() {
        navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItems = [
            UIBarButtonItem(
                image: .backDirectButton,
                style: .plain,
                target: self,
                action: #selector(backActionPressed)),
             UIBarButtonItem(customView: customView)
        ]
        setUpOpenUserProfileButton()
    }

    private func setUpOpenUserProfileButton() {
        let label = UILabel(frame: CGRect(x: 40, y: 8, width: 100, height: 44))
        label.text = conversationView?.viewModel.users[id].name
        label.textAlignment = .center
        label.sizeToFit()

        dialogUserProfileImage.sd_setImage(with: conversationView?.viewModel.users[id].profileImage)
        dialogUserProfileImage.contentMode = .scaleAspectFit
        dialogUserProfileImage.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        dialogUserProfileImage.layer.cornerRadius = 16
        dialogUserProfileImage.clipsToBounds = true

        customView.addSubview(dialogUserProfileImage)
        customView.addSubview(label)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(openUserProfile))
        customView.addGestureRecognizer(tapGesture)
    }

    @objc private func backActionPressed() {
        if let viewControllers = navigationController?.viewControllers,
           let previousVC = viewControllers.dropLast().last {
            navigationController?.popToViewController(previousVC, animated: true)
        }
    }

    @objc private func openUserProfile() {
        if let coordinator = coordinator {
            coordinator.didPressProfile(userId: id)
        }
    }
}
