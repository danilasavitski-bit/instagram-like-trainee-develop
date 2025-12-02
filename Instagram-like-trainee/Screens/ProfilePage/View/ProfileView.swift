//
//  ProfileView.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 23/04/2024.
//

import SwiftUI

struct ProfileView<Model:ProfilePageViewModelProtocol>: View {
    @ObservedObject private var viewModel: Model

    init(viewModel: Model) {
        self.viewModel = viewModel
        print("Real type:", type(of: viewModel.coordinator))

    }

    var body: some View {
        VStack {
            if let profileData = viewModel.data {
                if viewModel.coordinator is HomeCoordinator {
                    let coordinator = viewModel.coordinator as? HomeCoordinator
                    MainView(profileData: profileData, closeProfile: coordinator?.closeProfile)
                } else if viewModel.coordinator is MyProfileCoordinatorProtocol {
                    MainView(profileData: profileData)
                }
            } else {
                ProgressView(R.string.localizable.loading())
            }
        }
        .onAppear{
            print( viewModel.coordinator is MyProfileCoordinatorProtocol)
        }
        .navigationBarBackButtonHidden(true)
    }
}
