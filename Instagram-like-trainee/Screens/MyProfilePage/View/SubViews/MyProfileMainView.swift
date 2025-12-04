//
//  MainView.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 26/04/2024.
//

import SwiftUI

struct MyMainView: View {
    private var profileData: ProfileData
    private var openSettings: ()->Void

    init(profileData: ProfileData, openSettings: @escaping () -> Void) {
        self.profileData = profileData
        self.openSettings = openSettings
    }

    var body: some View {
        ScrollView {
            VStack {
                MyProfileNavigationView(profileName: profileData.profileName, openSettings: openSettings)
                HeaderView(profileImage: profileData.profileImage)
                DescriptionView(profileName: profileData.profileName, description: profileData.description)
                HStack(spacing: 5) {
                    createButton(name: "Change", color: .black)
                    createButton(name: "Share profile", color: .black)
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
