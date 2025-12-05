//
//  SettingsNavigationView.swift
//  Instagram-like-trainee
//
//  Created by  on 3.12.25.
//

import SwiftUI

struct SettingsNavigationView: View {
    let closeSettings: () -> Void
    init(closeSettings: @escaping () -> Void) {
        self.closeSettings = closeSettings
    }
    var body: some View {
        HStack{
            Button {
                closeSettings()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title)
                    .padding(10)
            }
            Spacer()
            Text("Settings and actions")
                .font(.title3)
                .bold()
            Spacer()
            Spacer()
        }
    }
}
