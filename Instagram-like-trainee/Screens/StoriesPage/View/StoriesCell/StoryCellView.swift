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
    @State var timerProgress: CGFloat
    @State var longTouchDetected: Bool = false
    @State var currentStoryIndex: Int = 0
    @State var player: AVPlayer?
    @State var isVideo:Bool = false
    @State var storyDuration:Double = 0
    @State private var itemControlObserver: NSKeyValueObservation?
    @State private var timerCancellable: Cancellable?
    
    let bundleIndex: Int
    
    var body: some View {
        
        ZStack{
            Color.black
                .ignoresSafeArea()
            GeometryReader{ proxy in
                if isVideo {
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
                    .frame(maxWidth:.infinity,maxHeight: .infinity, alignment: .center)
                }
                
                ZStack{
                    StoriesNavigationView(timerProgress: $timerProgress,
                                          storyBundle: $storyBundle,
                                          stopTimer: stopTimer,
                                          viewModel: viewModel)
                    VStack{
                        StoriesProgressBar(isStopped: $longTouchDetected,
                                           timerProgress: $timerProgress,
                                           storyBundle: $storyBundle)
                        TopBarView(isStopped: $longTouchDetected,
                                   storyBundle: $storyBundle,
                                   viewModel: viewModel)
                        Spacer()
                        StoriesBottomBar(isStopped: $longTouchDetected)
                    }
                }
                
                .rotation3DEffect(getAngle(proxy: proxy),
                                  axis: (x: 0, y: 1, z: 0),
                                  anchor: proxy.frame(in: .global).minX > 0 ? .leading : .trailing,
                                  perspective: 2.5)
                .frame(maxWidth:.infinity,maxHeight: .infinity, alignment: .center)
            }
            
            
        }
        
        .onLongPressGesture(minimumDuration: 1,pressing: { isPressing in
            if isPressing {
                player?.pause()
                withAnimation(.smooth) {
                    longTouchDetected = true
                }
            } else {
                player?.play()
                withAnimation(.smooth) {
                    longTouchDetected = false
                }
            }
        }, perform: {})
        .onAppear{
            isVideo = false
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
            isVideo = false
            player = nil
            configureVideo(withIndex: newValue)
        })
    }
    func startTimer(with duration: Double? = nil) {
        timerCancellable?.cancel()
        let t = Timer.publish(every: 0.1, on: .main, in: .common)
        viewModel.timer = t
        timerCancellable = t.autoconnect().sink { _ in
            guard !longTouchDetected else { return}
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
    
    func configureVideo(withIndex index: Int) {
        stopTimer()
        
        Task.detached {
            let url = await storyBundle.stories[index].content
            let video = await checkIfVideo(url: url)
            
            await MainActor.run {
                guard video else {
                    self.isVideo = false
                    self.player = nil
                    return
                }
                
                let newPlayer = AVPlayer(url: url)
                self.player = newPlayer
                self.isVideo = true
                self.player?.isMuted = false
                self.player?.play()
                
                // KVO для duration и таймера
                self.itemControlObserver?.invalidate()
                self.itemControlObserver = newPlayer.observe(\.currentItem?.status, options: [.initial, .new]) { player, _ in
                    if player.status == .readyToPlay,
                       self.timerCancellable == nil,
                       let duration = player.currentItem?.duration.seconds,
                       duration.isFinite && duration > 0 {
                        self.storyDuration = duration
                        self.startTimer(with: duration)
                    }
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
    
    func checkIfVideo(url: URL) async ->  Bool  {
        await withCheckedContinuation { continuation in
            let asset = AVURLAsset(url: url)
            let videoTracks = asset.tracks(withMediaType: .video)
            continuation.resume(returning:  !videoTracks.isEmpty)
        }
        
    }
    
}


