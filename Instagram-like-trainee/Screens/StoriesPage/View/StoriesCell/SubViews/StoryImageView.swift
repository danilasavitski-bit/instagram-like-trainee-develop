//
//  StoryImageView.swift
//  Instagram-like-trainee
//
//  Created by  on 26.12.25.
//

import SwiftUI
import AVKit

struct StoryImageView: View {
    @Binding var storyBundle: StoriesBundle
    @Binding var currentStoryIndex: Int
    var viewModel: StoriesScreenViewModel
    var bundleIndex: Int
    var stopTimer: () -> Void
    var startTimer: (Double?) -> Void
    
    var body: some View {
        AsyncImage(url: storyBundle.stories[currentStoryIndex].content, content: { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .tint(Color.gray)
                    .onAppear {
                        stopTimer()
                    }
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .onAppear{
                        startTimer(nil)
                        if !storyBundle.stories[currentStoryIndex].isSeen{
                            viewModel.markStoryAsSeen(story: storyBundle.stories[currentStoryIndex],
                                                      bundleIndex: bundleIndex)
                        }
                    }
                    .onChange(of:currentStoryIndex){ newValue in
                        if !storyBundle.stories[currentStoryIndex].isSeen{
                            viewModel.markStoryAsSeen(story: storyBundle.stories[currentStoryIndex],
                                                      bundleIndex: bundleIndex)
                        }
            }
            case .failure:
                Image("placeholder")
            @unknown default:
                Image("failure")
            }
        })
        .id(storyBundle.stories[currentStoryIndex].id)
    }
}

