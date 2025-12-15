//
//  EditPostView.swift
//  Instagram-like-trainee
//
//  Created by  on 12.12.25.
//

import SwiftUI

struct EditPostView: View {
    var viewModel: EditPostViewModel
    var body: some View {
        VStack{
            Image(uiImage: viewModel.image)
                .resizable()
            Button{
                viewModel.postStory()
            } label: {
                Text("Create post")
            }
        }
    }
}

