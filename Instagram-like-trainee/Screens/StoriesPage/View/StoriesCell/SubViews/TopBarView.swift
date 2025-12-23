//
//  TopBarView.swift
//  Instagram-like-trainee
//
//  Created by  on 23.12.25.
//

import SwiftUI

struct TopBarView: View {
    @Binding var isStopped:Bool
    @Binding var storyBundle: StoriesBundle
    var viewModel: StoriesScreenViewModel
    var body: some View {
        HStack(spacing:13){
            if !isStopped{
                AsyncImage(url: storyBundle.user.profileImage) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35,height: 35)
                        .clipShape(Circle())
                        .padding(.vertical,10)
                        .padding(.leading,10)
                } placeholder: {
                    EmptyView()
                }
                Text(storyBundle.user.name)
                    .font(.subheadline)
                    .foregroundStyle(.white)
                Spacer()
                Button{
                    
                }label:{
                    Image(systemName:  "ellipsis")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
                Button{
                    viewModel.closeStories()
                }label:{
                    Image(systemName: "xmark")
                        .font(.title2)
                        .foregroundStyle(.white)
                }
            }
        }
    }
}

