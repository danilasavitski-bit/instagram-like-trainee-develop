//
//  SettingsViewModel.swift
//  Instagram-like-trainee
//
//  Created by  on 3.12.25.
//

import SwiftUI

protocol SettingsModel : ObservableObject{
    var coordinator:MyProfileCoordinatorProtocol?{ get set }
    var categories: [Category] { get }
}

class SettingsViewModel: SettingsModel{
    var coordinator: MyProfileCoordinatorProtocol?
    let categories: [Category] = [
        Category(title: "Your account",
                 items: [
                    CategoryItem(view: AccountCellView())
                 ]),
        Category(title: "How you use instagram",
                 items: [
                    CategoryItem(view: SettingsCellView(image: "bookmark",
                                                        text: "Saved")),
                    CategoryItem(view: SettingsCellView(image: "clock.arrow.trianglehead.clockwise.rotate.90.path.dotted",
                                                        text: "Archive")),
                    CategoryItem(view: SettingsCellView(image: "waveform.path.ecg.rectangle",
                                                        text: "Your actions")),
                    CategoryItem(view: SettingsCellView(image: "bell",
                                                        text: "Notifications")),
                    CategoryItem(view: SettingsCellView(image: "clock",
                                                        text: "Time menegment"))
                 ]),
        Category(title: "Who can see your content",
                 items: [
                    CategoryItem(view: Text("Example"))
                 ]),
        Category(title: "Your accecability",
                 items: [
                    CategoryItem(view: Text("Example"))
                 ]),
        Category(title: "What you see",
                 items: [
                    CategoryItem(view: Text("Example"))
                 ]),
        Category(title: "Your app and media",
                 items: [
                    CategoryItem(view: Text("Example"))
                 ]),
        Category(title: "Family center",
                 items: [
                    CategoryItem(view: Text("Example"))
                 ]),
        Category(title: "For proffesional accounts",
                 items: [
                    CategoryItem(view: Text("Example"))
                 ]),
        Category(title: "Your orders and charings",
                  items: [
                     CategoryItem(view: Text("Example"))
                  ]),
        Category(title: "Information and support",
                  items: [
                     CategoryItem(view: Text("Example"))
                  ]),
        Category(title: "Other Meta products",
                  items: [
                     CategoryItem(view: Text("Example"))
                  ])
        
    ]
    init(coordinator: MyProfileCoordinatorProtocol? = nil) {
        self.coordinator = coordinator
    }
    func didPressedCloseSettings(){
        coordinator?.closeSettings()
    }
}
