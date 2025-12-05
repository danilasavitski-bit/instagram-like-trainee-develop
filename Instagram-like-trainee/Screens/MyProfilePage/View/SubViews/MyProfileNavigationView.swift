//
//  NavigationView.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 25/04/2024.
//

import SwiftUI

struct MyProfileNavigationView: View {
    private var profileName: String
    private let openSettings: () -> Void
    init(profileName: String, openSettings: @escaping () -> Void) {
        self.profileName = profileName
        self.openSettings = openSettings
    }

    var body: some View {
        HStack {
            Spacer()
            Spacer()
            Text(profileName)
                .font(.title3)
                .bold()
            Spacer()
            Button{
                openSettings()
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.title)
                    .padding(10)
            }
            
        }
    }
}
