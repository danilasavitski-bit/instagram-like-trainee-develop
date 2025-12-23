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
    @State private var timer: Timer.TimerPublisher?
    @State private var timerCancellable: Cancellable?
    @State var timerProgress: CGFloat 
    @State var isStopped: Bool = false
    @State var currentStoryIndex: Int = 0
    
    let bundleIndex: Int
    var body: some View {
        GeometryReader{ proxy in
                   let index = currentStoryIndex
                    AsyncImage(url: storyBundle.stories[index].content) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
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
                            
                    } placeholder: {
                        EmptyView()
                    }
            .frame(maxWidth:.infinity,maxHeight: .infinity, alignment: .center)
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
            .frame(maxWidth:.infinity,maxHeight: .infinity, alignment: .center)
            .rotation3DEffect(getAngle(proxy: proxy),
                              axis: (x: 0, y: 1, z: 0),
                              anchor: proxy.frame(in: .global).minX > 0 ? .leading : .trailing,
                              perspective: 2.5)
        }
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
        timer = t
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
        timer = nil
    }


    func getAngle(proxy:GeometryProxy) -> Angle {
        let progress = proxy.frame(in: .global).minX / proxy.size.width
        let rotationAngle: CGFloat = 45
        let degrees = rotationAngle * progress
        return Angle(degrees: Double(degrees))
    }
}


