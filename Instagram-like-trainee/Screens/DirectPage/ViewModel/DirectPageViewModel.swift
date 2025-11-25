//
//  DirectPageViewModel.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 16.04.24.
//

import UIKit

final class DirectPageViewModel: DirectPageViewModelProtocol {
    private var dialogs = [Dialog]()
    private var jsonService: JsonService
    private var currentDialog: Dialog?
    private var users = [User]()

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

    init(jsonService: JsonService) {
        self.jsonService = jsonService
        self.fetchData()
    }

    func getUserData(id: Int) -> HomeScreenUserData? {
        return getUserWithId(id)?.getHomeScreenUser()
    }

    private func fetchData() {
        let dialogsJsonPath = Bundle.main.path(forResource: R.string.localizable.dialogs(),
                                               ofType: R.string.localizable.json())
        let usersJsonPath = Bundle.main.path(forResource: R.string.localizable.users(),
                                               ofType: R.string.localizable.json())
        let dialogsData = (
            jsonService.fetchFromJson(
                objectType: dialogs,
                filePath: dialogsJsonPath ?? ""
            )
        )
        switch dialogsData {
        case .success(let success):
            dialogs.append(contentsOf: success)
            self.currentDialog = self.dialogs.popLast()
        case .failure(let failure):
            print(failure.description)
        }
        let usersData = (
            jsonService.fetchFromJson(
                objectType: users,
                filePath: usersJsonPath ?? ""
            )
        )
        switch usersData {
        case .success(let success):
            users.append(contentsOf: success)
            print("\(users)")
        case .failure(let failure):
            print(failure.description)
        }
    }

    private func getUserWithId(_ id: Int) -> User? {
        return users.filter({ $0.id == id }).first
    }
}
