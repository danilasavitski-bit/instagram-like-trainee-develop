//
//  DialogHeaderView.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 17.05.24.
//

import SwiftUI

struct DialogHeaderView: View {

    @StateObject var viewModel: ConversationView.ViewModel
    var coordinator: HomeCoordinator
    var id: Int

    var body: some View {
        AsyncImage(url: viewModel.getCurrentUser()?.profileImage) { image in
            image.resizable()
                .clipShape(.circle)
                .aspectRatio(contentMode: .fit)
                .frame(width: 80.0, height: 80.0)
        } placeholder: {
            ProgressView()
        }
        Text(viewModel.getCurrentUser()?.name ?? "")
            .font(.title)
        Text(R.string.localizable.instagram())
            .foregroundStyle(.gray)
        ZStack {
            Rectangle()
                .frame(width: 150, height: 30)
                .foregroundColor(.gray)
                .clipShape(.rect(cornerSize: CGSize(width: 6, height: 6), style: .circular))
            Button(action: {
                    coordinator.openProfile(userId: id)
            }, label: {
                Text(R.string.localizable.showProfile())
                    .foregroundStyle(.white)
            })
        }
    }
}
