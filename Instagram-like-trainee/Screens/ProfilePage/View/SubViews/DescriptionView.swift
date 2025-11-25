//
//  DescriptionView.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 25/04/2024.
//

import SwiftUI

struct DescriptionView: View {
    private var profileName: String
    private var description: String

    init(profileName: String, description: String) {
        self.profileName = profileName
        self.description = description
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(profileName.split(separator: " ").first.map(String.init) ?? "")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                Text(description)
                    .font(.subheadline)
                    .multilineTextAlignment(.leading)
            }
            Spacer()
        }
        .padding([.leading, .trailing], 10)
    }
}
