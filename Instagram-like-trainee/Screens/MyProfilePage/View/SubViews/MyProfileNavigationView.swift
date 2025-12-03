//
//  NavigationView.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 25/04/2024.
//

import SwiftUI

struct MyProfileNavigationView: View {
    private var profileName: String
    private var closeProfile: (() -> Void)?

    init(profileName: String, closeProfile:  (() -> Void)? = nil) {
        self.profileName = profileName
        self.closeProfile = closeProfile
    }

    var body: some View {
        HStack {
            Spacer()
            Spacer()
            Text(profileName)
                .font(.title3)
                .bold()
            Spacer()
            Image(systemName: "line.3.horizontal")
                .font(.title)
                .padding(10)
        }
    }
}
