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
            ZStack{
                
                   let index = currentStoryIndex
                
                    AsyncImage(url: storyBundle.stories[index].content) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .onAppear{
                                print("worked",currentStoryIndex )
                                viewModel.markStoryAsSeen(story: storyBundle.stories[currentStoryIndex],
                                                          bundleIndex: bundleIndex)
                            }
                            .onChange(of:currentStoryIndex){ newValue in
                                print ("worked", newValue)
                                viewModel.markStoryAsSeen(story: storyBundle.stories[newValue],
                                                          bundleIndex: bundleIndex)
                            }
                            
                    } placeholder: {
                        EmptyView()
                    }
            }
            .frame(maxWidth:.infinity,maxHeight: .infinity, alignment: .center)
            .overlay(
                HStack{
                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            if timerProgress - 1 < 0 {
                                updateStory(forward: false)
                            } else {
                                timerProgress = CGFloat(Int(timerProgress) - 1)
                            }
                        }
                    Rectangle()
                        .fill(.black.opacity(0.01))
                        .onTapGesture {
                            if timerProgress > CGFloat(storyBundle.stories.count - 1) {
                                updateStory()
                            } else {
                                timerProgress = CGFloat(Int(timerProgress) + 1)
                            }
                        }
                }
            )
            .overlay(
                HStack(spacing:13){
                    if !isStopped{
                        AsyncImage(url: storyBundle.user.profileImage) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 35,height: 35)
                                .clipShape(Circle())
                                .padding(.vertical,10)
                                .padding(.leading,10)
                        } placeholder: {
                            EmptyView()
                        }
                        Text(storyBundle.user.name)
                            .font(.subheadline)
                            .foregroundStyle(.white)
                        Spacer()
                        Button{
                            
                        }label:{
                            Image(systemName:  "ellipsis")
                                .font(.title2)
                                .foregroundStyle(.white)
                        }
                        Button{
                            viewModel.closeStories()
                        }label:{
                            Image(systemName: "xmark")
                                .font(.title2)
                                .foregroundStyle(.white)
                        }
                    }
                },alignment: .topTrailing
            )
            .overlay(
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
                .padding(.horizontal),
                alignment: .top
            )
            .overlay(
                HStack {
                   if !isStopped{
                       Text("Enter your message...")
                            .foregroundStyle(.white.opacity(0.7))
                            .frame(maxWidth: .infinity,alignment: .leading)
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .overlay(
                                Capsule()
                                    .stroke(Color.white.opacity(0.7), lineWidth: 1)
                                    .frame(maxWidth: .infinity)
                            )
                            .padding()
                        Button{
                            
                        }label:{
                            Image(systemName: "heart")
                                .foregroundStyle(.white)
                                .font(.system(size: 25))
                        }
                        Button{
                            
                        }label:{
                            Image(systemName: "message")
                                .foregroundStyle(.white)
                                .font(.system(size: 25))
                        }
                   }
                },
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
            print("rounded progress - ", roundedProgress)
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
                updateStory()
            }
        }
    }
        
    func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
        timer = nil
//        timerProgress = 0
    }

    func updateStory(forward: Bool = true){
        let index = min(Int(timerProgress),storyBundle.stories.count - 1)
        print(timerProgress)
        let story = storyBundle.stories[index]
        if !forward {
            if let first = storyBundle.stories.first, first.id != story.id {
                let bundleIndex = viewModel.storiesBundles.firstIndex{ currentBundle in
                    return storyBundle.id == currentBundle.id
                } ?? 0
                withAnimation {
                    viewModel.currentBundleIndex = bundleIndex - 1
                }
            }
        }
        if let last = storyBundle.stories.last, last.id == story.id {
            if let lastBundle = viewModel.storiesBundles.last,lastBundle.id == storyBundle.id{
                stopTimer()
                viewModel.closeStories()
//                timerProgress = 0
            } else {
                let bundleIndex = viewModel.currentBundleIndex
                if bundleIndex < viewModel.storiesBundles.count - 1{
                    withAnimation {
                        viewModel.currentBundleIndex = bundleIndex + 1
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
}


