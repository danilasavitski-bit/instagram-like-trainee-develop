//
//  StoryCellOverlay.swift
//  Instagram-like-trainee
//
//  Created by  on 23.12.25.
//

import SwiftUI

struct StoriesNavigationView: View {
    @Binding var timerProgress: CGFloat
    @Binding var storyBundle: StoriesBundle
    var stopTimer: () -> Void
    var viewModel: StoriesScreenViewModel
    var body: some View {
        HStack{
            Rectangle()
                .fill(.black.opacity(0.01))
                .onTapGesture {
                    if timerProgress - 1 < 0 {
                        viewModel.updateStory(forward: false, storyBundle: storyBundle, timerProgress: timerProgress, stopTimer: stopTimer)
                    } else {
                        timerProgress = CGFloat(Int(timerProgress) - 1)
                    }
                }
            Rectangle()
                .fill(.black.opacity(0.01))
                .onTapGesture {
                    if timerProgress > CGFloat(storyBundle.stories.count - 1) {
                        viewModel.updateStory(storyBundle: storyBundle, timerProgress: timerProgress, stopTimer: stopTimer)
                    } else {
                        timerProgress = CGFloat(Int(timerProgress) + 1)
                    }
                }
        }
    }
}
