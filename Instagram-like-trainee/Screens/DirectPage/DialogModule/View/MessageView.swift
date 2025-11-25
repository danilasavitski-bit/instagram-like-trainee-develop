//
//  MessageView.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 24.04.24.
//

import SwiftUI

struct MessageView: View {

    @StateObject var viewModel: ConversationView.ViewModel
    var currentMessage: Dialog
    var profileImageURL: URL
    var body: some View {
        HStack(alignment: .bottom, spacing: 15.0) {
            if currentMessage.usersId.first == 0 {
                AsyncImage(url: profileImageURL) { image in
                    image.resizable()
                        .clipShape(.circle)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                } placeholder: {
                    ProgressView()
                }
            } else {
                Spacer()
            }
            if let text = currentMessage.messages.first?.text,
               let currentUserID = currentMessage.usersId.first {
                ContentMessageView(contentMessage: text, currentUserID: currentUserID)
            }
        }
    }
}
