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
                StoryCellView(storyBundle: $viewModel.storiesBundles[index],viewModel: viewModel, bundleIndex: index)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(maxWidth: .infinity,maxHeight: .infinity)
        .background(.black)
    }
}

//#Preview {
//    let viewModel = StoriesScreenViewModel()
//    StoriesScreenView(viewModel: viewModel)
//}
