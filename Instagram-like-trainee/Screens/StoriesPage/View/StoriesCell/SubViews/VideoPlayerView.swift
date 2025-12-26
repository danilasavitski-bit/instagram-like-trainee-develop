//
//  VideoPlayer.swift
//  Instagram-like-trainee
//
//  Created by  on 26.12.25.
//

import SwiftUI
import AVKit

struct VideoPlayerView: View {
    @Binding var player: AVPlayer?
    @Binding var storyBundle: StoriesBundle
    @Binding var currentStoryIndex: Int
    var viewModel: StoriesScreenViewModel
    var bundleIndex: Int
    
    var body: some View {
        VideoPlayer(player: player)
            .id(storyBundle.stories[currentStoryIndex].id)
            .onAppear{
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
    }
}
