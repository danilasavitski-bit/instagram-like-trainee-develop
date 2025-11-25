//
//  ProfileView.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 23/04/2024.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject private var viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            if let profileData = viewModel.data {
                MainView(profileData: profileData, closeProfile: viewModel.closeProfile)
            } else {
                ProgressView(R.string.localizable.loading())
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
