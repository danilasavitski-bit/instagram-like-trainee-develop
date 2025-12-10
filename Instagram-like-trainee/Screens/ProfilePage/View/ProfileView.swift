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
    }

    var body: some View {
        VStack {
            if let profileData = viewModel.data {
                MainView(profileData: profileData, closeProfile: viewModel.coordinator!.closePage)
            } else {
                ProgressView(R.string.localizable.loading())
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
