//
//  NavigationView.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 25/04/2024.
//

import SwiftUI

struct NavigationView: View {
    private var profileName: String
    private var closeProfile: (() -> Void)?

    init(profileName: String, closeProfile:  (() -> Void)? = nil) {
        self.profileName = profileName
        self.closeProfile = closeProfile
    }

    var body: some View {
        HStack {
            if closeProfile != nil {
                Button(action: {
                    self.closeProfile!()
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .padding(10)
                })
            }
            Spacer()
            Text(profileName)
                .font(.title3)
                .bold()
            Spacer()
            Image(systemName: "ellipsis")
                .font(.title)
                .padding(10)
        }
    }
}
