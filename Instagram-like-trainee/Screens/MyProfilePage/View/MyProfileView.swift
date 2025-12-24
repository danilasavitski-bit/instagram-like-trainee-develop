//
//  ProfileView.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 23/04/2024.
//

import SwiftUI

struct MyProfileView<Model:MyProfilePageModel>: View {
    @ObservedObject private var viewModel: Model

    init(viewModel: Model) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            if let profileData = viewModel.data {
                MyMainView(profileData: profileData, openSettings: viewModel.coordinator?.openSettings ?? {print("no coordinator at MY PROFILE VIEW")})
            } else {
                ProgressView(R.string.localizable.loading())
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
