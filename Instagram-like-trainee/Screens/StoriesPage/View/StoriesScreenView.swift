//
//  StoriesScreenView.swift
//  Instagram-like-trainee
//
//  Created by  on 8.12.25.
//

import SwiftUI

struct StoriesScreenView: View {
    @ObservedObject var viewModel: StoriesScreenViewModel
    
    var body: some View {
        TabView(selection: $viewModel.currentBundleIndex) {
            
            ForEach($viewModel.storiesBundles.indices, id: \.self){ index in
                StoryCellView(storyBundle: $viewModel.storiesBundles[index],
                              viewModel: viewModel,
                              timerProgress: calculateCurrentStoryIndex(for: viewModel.storiesBundles[index]),
                              bundleIndex: index
                              )
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(.black)
    }
    func calculateCurrentStoryIndex(for bundle: StoriesBundle) -> CGFloat {
        let seenStoriesCount = bundle.stories.filter({$0.isSeen}).count
        return CGFloat(seenStoriesCount)
    }
}

