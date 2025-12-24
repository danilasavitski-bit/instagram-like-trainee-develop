//
//  DirectPageViewModel.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 16.04.24.
//

import UIKit
import Combine

protocol DirectPage {
    var dialogsCount: Int { get }
    var messageCount: Int { get }
    var usersCount: Int { get }
    var messagePreview: String { get }
    var dataUpdatedPublisher: Published<Bool>.Publisher { get }
    func getUserData(id: Int) -> HomeScreenUserData?
    func openDialog(_ id: Int)
   
}

final class DirectPageViewModel: DirectPage {
    @Published var dataUpdated: Bool = false
    var dataUpdatedPublisher: Published<Bool>.Publisher { $dataUpdated }
    
    var dialogsCount: Int {
        return dialogs.count
    }

    var messageCount: Int {
        return dialogs.last?.messages.count ?? 0
    }

    var usersCount: Int {
        return users.count
    }

    var messagePreview: String {
        guard let text = dialogs.last?.messages.last?.text else { return "" }
        return text
    }
    
    private var dialogs = [Dialog]()
    private var networkService: NetworkService
    private var currentDialog: Dialog?
    private var users = [User]()
    private var coordinator: DirectCoordinator
    private var cancellabeles: Set<AnyCancellable> = []

    init(coordinator: DirectCoordinator, networkService: NetworkService) {
        self.coordinator = coordinator
        self.networkService = networkService
        linkData()
    }
    
    func getUserData(id: Int) -> HomeScreenUserData? {
        return getUserWithId(id)?.getHomeScreenUser()
    }

    func openDialog(_ id: Int) {
        coordinator.openDialogPressed(id)
    }
    
    private func linkData() {
        Publishers.CombineLatest(
            networkService.$users,
            networkService.$dialogs
        )
        .filter { users, dialogs in
                !users.isEmpty &&
                !dialogs.isEmpty
            }
            .sink { users,dialogs in
                self.users = users
                self.dialogs = dialogs
                self.dataUpdated = true
            }
            .store(in: &cancellabeles)
    }
    
    private func getUserWithId(_ id: Int) -> User? {
        guard let user = users.filter({ user in
            user.id == id
        }).first else {
            return nil
        }
        return user
    }
}

