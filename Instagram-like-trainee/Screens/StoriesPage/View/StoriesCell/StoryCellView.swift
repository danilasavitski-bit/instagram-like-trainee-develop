//
//  StoryCellView.swift
//  Instagram-like-trainee
//
//  Created by  on 8.12.25.
//

import SwiftUI
import Combine
import AVKit

struct StoryCellView: View {
    
    @Binding var storyBundle: StoriesBundle
    @ObservedObject var viewModel: StoriesScreenViewModel
    @State private var itemControlObserver: NSKeyValueObservation?
    @State private var timerCancellable: Cancellable?
    @State var timerProgress: CGFloat 
    @State var isStopped: Bool = false
    @State var currentStoryIndex: Int = 0
    @State var player: AVPlayer?
    @State var isVideoVar:Bool = false
    @State var storyTime:Double = 0
    
    let bundleIndex: Int
    
    var body: some View {
        GeometryReader{ proxy in
            Rectangle()
                .overlay{
                    if isVideoVar {
                        VideoPlayerView(player: $player,
                                        storyBundle: $storyBundle,
                                        currentStoryIndex: $currentStoryIndex,
                                        viewModel: viewModel,
                                        bundleIndex: bundleIndex)
                    } else {
                        StoryImageView( storyBundle: $storyBundle,
                                        currentStoryIndex: $currentStoryIndex,
                                        viewModel: viewModel,
                                        bundleIndex: bundleIndex,
                                        stopTimer: stopTimer,
                                        startTimer: startTimer)

                }
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
                .rotation3DEffect(getAngle(proxy: proxy),
                                  axis: (x: 0, y: 1, z: 0),
                                  anchor: proxy.frame(in: .global).minX > 0 ? .leading : .trailing,
                                  perspective: 2.5)
        }
        
        .onLongPressGesture(minimumDuration: 1,pressing: { isPressing in
                                if isPressing {
                                    player?.pause()
                                    withAnimation(.smooth) {
                                        isStopped = true
                                    }
                                } else {
                                    player?.play()
                                    withAnimation(.smooth) {
                                        isStopped = false
                                    }
                                }
        }, perform: {})
        .onAppear{
            isVideoVar = false
            player = nil
            configureVideo(withIndex: currentStoryIndex)
            let roundedProgress = Int(timerProgress)
            guard roundedProgress != storyBundle.stories.count else {
                timerProgress = CGFloat(roundedProgress - 1 )
                return }
            timerProgress = CGFloat(roundedProgress)
        }
        .onDisappear {
            player = nil
            stopTimer()
        }
        .onChange(of: currentStoryIndex, { _, newValue in
            isVideoVar = false
            player = nil
            configureVideo(withIndex: newValue)
        })
    }
    func startTimer(with duration: Double? = nil) {
        timerCancellable?.cancel()
        let t = Timer.publish(every: 0.1, on: .main, in: .common)
        viewModel.timer = t
        timerCancellable = t.autoconnect().sink { _ in
            guard !isStopped else { return}
            if timerProgress < CGFloat(storyBundle.stories.count) {
                withAnimation{
                    guard let duration else {
                        timerProgress += 0.025
                        return
                    }
                    let step = 1/(duration * 10)
                    timerProgress += step
                }
                currentStoryIndex = min(Int(timerProgress), storyBundle.stories.count - 1)
            } else {
                viewModel.updateStory(storyBundle: storyBundle,
                                      timerProgress: timerProgress,
                                      stopTimer: stopTimer)
            }
        }
    }
        
    func stopTimer() {
        itemControlObserver?.invalidate()
        timerCancellable?.cancel()
        timerCancellable = nil
        viewModel.timer = nil
    }

    func configureVideo(withIndex index: Int){
        stopTimer()
        Task{
            let video =  isVideo(url: storyBundle.stories[index].content)
            await MainActor.run {
                if video {
                    player = AVPlayer(url: storyBundle.stories[index].content)
                    itemControlObserver = player?.observe(\.currentItem?.status, options: [.initial,.new], changeHandler: { player, _ in
                        if player.status == .readyToPlay{
                                            Task{
                                                await MainActor.run{
                                                    storyTime = player.currentItem?.duration.seconds ?? 0
                                                    startTimer(with: storyTime)
                                                    print("story time is:", storyTime)
                                                }
                                            }
                                        }
                                    })
                    player?.play()
                    player?.isMuted = false
                    isVideoVar = true
                } else {
                    isVideoVar = false
                }
            }
        }
    }

    func getAngle(proxy:GeometryProxy) -> Angle {
        let progress = proxy.frame(in: .global).minX / proxy.size.width
        let rotationAngle: CGFloat = 45
        let degrees = rotationAngle * progress
        return Angle(degrees: Double(degrees))
    }
    
    func isVideo(url: URL) -> Bool {
        let asset = AVURLAsset(url: url)
        let videoTracks = asset.tracks(withMediaType: .video)
        return !videoTracks.isEmpty
    }

}


