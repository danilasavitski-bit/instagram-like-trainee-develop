//
//  HeaderView.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 25/04/2024.
//

import SwiftUI

struct HeaderView: View {
    private var profileImage: URL

    init(profileImage: URL) {
        self.profileImage = profileImage
    }

    var body: some View {
        HStack {
            AsyncImage(url: profileImage) { image in
                image
                    .resizable()
                    .frame(width: 80, height: 80)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
            } placeholder: {
                ProgressView()
            }
            .overlay(
                Circle()
                    .stroke(LinearGradient(
                        colors: [.orange, .red, .purple],
                        startPoint: .leading,
                        endPoint: .trailing), lineWidth: 3)
                    .frame(width: 88, height: 88)
            )
            Spacer()
            crateSectionItem(type: .posts(value: 123))
            Spacer()
            crateSectionItem(type: .followers(value: 456))
            Spacer()
            crateSectionItem(type: .following(value: 798))
        }
        .padding()
    }

    func crateSectionItem(type: ProfileItems) -> some View {
        Button {
            // TODO: Show associated view
        } label: {
            VStack {
                Text("\(type.value)")
                Text(type.title)
            }
            .foregroundColor(.black)
        }
    }
}

extension HeaderView {
    enum ProfileItems {
        case posts(value: Int)
        case followers(value: Int)
        case following(value: Int)

        var title: String {
            switch self {
            case .posts:
                "Posts"
            case .followers:
                "Followers"
            case .following:
                "Following"
            }
        }
        var value: Int {
            switch self {
            case .posts(let value):
                value
            case .followers(let value):
                value
            case .following(let value):
                value
            }
        }
    }
}
