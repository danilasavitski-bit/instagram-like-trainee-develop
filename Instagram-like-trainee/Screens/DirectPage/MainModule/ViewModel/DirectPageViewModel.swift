//
//  DirectPageViewModel.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 16.04.24.
//

import UIKit

protocol DirectPage {
    var dialogsCount: Int { get }
    var messageCount: Int { get }
    var usersCount: Int { get }
    var messagePreview: String { get }
    func getUserData(id: Int) -> HomeScreenUserData?
    func openDialog(_ id: Int)
}

final class DirectPageViewModel: DirectPage {
    private var dialogs = [Dialog]()
    private var jsonService: JsonService
    private var currentDialog: Dialog?
    private var users = [User]()
    private var coordinator: DirectCoordinator

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

    init(coordinator: DirectCoordinator, jsonService: JsonService) {
        self.coordinator = coordinator
        self.jsonService = jsonService
        self.fetchData()
    }

    func getUserData(id: Int) -> HomeScreenUserData? {
        return getUserWithId(id)?.getHomeScreenUser()
    }

    func openDialog(_ id: Int) {
        coordinator.openDialogPressed(id)
    }

    private func fetchData() {
        let dialogsJsonPath = Bundle.main.path(
            forResource: R.string.localizable.dialogs(),
            ofType: R.string.localizable.json())

        let usersJsonPath = Bundle.main.path(
            forResource: R.string.localizable.users(),
            ofType: R.string.localizable.json())

        let dialogsData = getDialogsData(from: dialogsJsonPath)
        validateDialogsData(dialogsData: dialogsData)
        
        let usersData = getUsersData(from: usersJsonPath)
        validateUsersData(usersData: usersData)
    }
    
    private func getUsersData(from jsonPath: String?) ->  Result<[User], ParseError> {
        let usersData = (
            jsonService.fetchFromJson(
                objectType: users,
                filePath: jsonPath ?? ""
            )
        )
        return usersData
    }
    
    private func getDialogsData(from jsonPath: String?) ->  Result<[Dialog], ParseError> {
        let dialogsData = (
            jsonService.fetchFromJson(
                objectType: dialogs,
                filePath: jsonPath ?? ""
            )
        )
        return dialogsData
    }
    
    private func validateUsersData(usersData: Result<[User], ParseError>) {
        switch usersData {
        case .success(let data):
            users.append(contentsOf: data)
            print("\(users)")
        case .failure(let failure):
            print(failure.description)
        }
    }
    
    private func validateDialogsData(dialogsData: Result<[Dialog], ParseError>){
        switch dialogsData {
        case .success(let data):
            dialogs.append(contentsOf: data)
            self.currentDialog = self.dialogs.popLast()
        case .failure(let failure):
            print(failure.description)
        }
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

