//
//  StoryCellView.swift
//  Instagram-like-trainee
//
//  Created by  on 8.12.25.
//

import SwiftUI
import Combine

struct StoryCellView: View {
    
    @Binding var storyBundle: StoriesBundle
    @ObservedObject var viewModel: StoriesScreenViewModel
    @State private var timerCancellable: Cancellable?
    @State var timerProgress: CGFloat 
    @State var isStopped: Bool = false
    @State var currentStoryIndex: Int = 0
    
    let bundleIndex: Int
    var body: some View {
        GeometryReader{ proxy in
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
                            startTimer()
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
            .frame(maxWidth:.infinity,maxHeight: .infinity, alignment: .center)
            .rotation3DEffect(getAngle(proxy: proxy),
                              axis: (x: 0, y: 1, z: 0),
                              anchor: proxy.frame(in: .global).minX > 0 ? .leading : .trailing,
                              perspective: 2.5)
        }
        .overlay(
            StoriesNavigationView(timerProgress: $timerProgress,
                                storyBundle: $storyBundle,
                                stopTimer: stopTimer,
                                viewModel: viewModel)
        )
        .overlay(
            TopBarView(isStopped: $isStopped,
                       storyBundle: $storyBundle,
                       viewModel: viewModel)
          ,alignment: .topTrailing
        )
        .overlay(
            StoriesProgressBar(isStopped: $isStopped,
                               timerProgress: $timerProgress,
                               storyBundle: $storyBundle),
            alignment: .top
        )
        .overlay(
            StoriesBottomBar(isStopped: $isStopped),
            alignment: .bottom
        )

        .onLongPressGesture(minimumDuration: 1,pressing: { isPressing in
                                if isPressing {
                                    withAnimation(.smooth) {
                                        isStopped = true
                                    }
                                } else {
                                    withAnimation(.smooth) {
                                        isStopped = false
                                    }
                                }
        }, perform: {
            
        })
        .onAppear{
            let roundedProgress = Int(timerProgress)
            guard roundedProgress != storyBundle.stories.count else {
                timerProgress = CGFloat(roundedProgress - 1 )
                return }
            timerProgress = CGFloat(roundedProgress)
        }
        .onDisappear {
            stopTimer()
        }
        .task(id: viewModel.currentBundleIndex) {
            if viewModel.currentBundleIndex == bundleIndex {
                startTimer()
            } else {
                stopTimer()
            }
        }
    }
    func startTimer() {
        let t = Timer.publish(every: 0.1, on: .main, in: .common)
        viewModel.timer = t
        timerCancellable = t.autoconnect().sink { _ in
            guard !isStopped else { return}
            if timerProgress < CGFloat(storyBundle.stories.count) {
                timerProgress += 0.03
                currentStoryIndex = min(Int(timerProgress), storyBundle.stories.count - 1)
            } else {
                viewModel.updateStory(storyBundle: storyBundle,
                                      timerProgress: timerProgress,
                                      stopTimer: stopTimer)
            }
        }
    }
        
    func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
        viewModel.timer = nil
    }


    func getAngle(proxy:GeometryProxy) -> Angle {
        let progress = proxy.frame(in: .global).minX / proxy.size.width
        let rotationAngle: CGFloat = 45
        let degrees = rotationAngle * progress
        return Angle(degrees: Double(degrees))
    }
}


