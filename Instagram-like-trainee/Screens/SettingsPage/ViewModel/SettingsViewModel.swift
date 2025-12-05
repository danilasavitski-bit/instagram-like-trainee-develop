//
//  SettingsViewModel.swift
//  Instagram-like-trainee
//
//  Created by  on 3.12.25.
//

import SwiftUI

protocol SettingsModel : ObservableObject{
    var coordinator:MyProfileCoordinatorProtocol?{ get set }
}

class SettingsViewModel: SettingsModel{
    var coordinator: MyProfileCoordinatorProtocol?
    
    init(coordinator: MyProfileCoordinatorProtocol? = nil) {
        self.coordinator = coordinator
    }
    func didPressedCloseSettings(){
        coordinator?.didPressCloseSettings()
    }
}
