//
//  StoriesProgressBar.swift
//  Instagram-like-trainee
//
//  Created by  on 23.12.25.
//

import SwiftUI

struct StoriesProgressBar: View {
    @Binding var isStopped: Bool
    @Binding var timerProgress: CGFloat
    @Binding var storyBundle: StoriesBundle
    
    var body: some View {
        HStack(spacing: 5) {
            if !isStopped {
                ForEach(storyBundle.stories.indices, id: \.self){ index in
                    GeometryReader{ proxy in
                        let width = proxy.size.width
                        let progress = timerProgress - CGFloat(index)
                        let perfectProgress = min(max(progress, 0), 1)
                        
                        Capsule()
                            .fill(.gray.opacity(0.5))
                            .overlay(
                                Capsule()
                                    .fill(.white)
                                    .frame(width: width * perfectProgress),
                                alignment: .leading
                            )
                    }
                }
            }
        }
        .frame(height: 1.4)
        .padding(.horizontal)    }
}

