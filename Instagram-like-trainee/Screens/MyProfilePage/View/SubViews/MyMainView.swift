//
//  MainView.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 26/04/2024.
//

import SwiftUI

struct MyMainView: View {
    private var profileData: ProfileData
    private var closeProfile: (() -> Void)?

    init(profileData: ProfileData, closeProfile: (() -> Void)? = nil) {
        self.profileData = profileData
        self.closeProfile = closeProfile
    }

    var body: some View {
        ScrollView {
            VStack {
//                NavigationView(profileName: profileData.profileName, closeProfile: closeProfile )
                HeaderView(profileImage: profileData.profileImage)
                DescriptionView(profileName: profileData.profileName, description: profileData.description)
                HStack(spacing: 5) {
                    createButton(name: R.string.localizable.follow(), color: .black)
                    createButton(name: R.string.localizable.message(), color: .black)
                    createButton(name: R.string.localizable.email(), color: .black)
                }
                .padding(3)
                PostFeedView(posts: profileData.posts)
            }
        }
    }

    func createButton(name: String, color: Color) -> some View {
        Button {
            // TODO: Add associated action
        } label: {
            Text(name)
                .font(.subheadline)
                .bold()
        }
        .frame(maxWidth: .infinity, minHeight: 30, maxHeight: 35)
        .background(color == .white ? .blue : .profileButtonBackground)
        .cornerRadius(6)
        .foregroundStyle(color)
    }
}
