//
//  EditPostView.swift
//  Instagram-like-trainee
//
//  Created by  on 12.12.25.
//

import SwiftUI

struct EditPostView: View {
    @ObservedObject var viewModel: EditPostViewModel
    @State var openSheet: Bool = false
    var body: some View {
        ZStack{
            Color.black
                .ignoresSafeArea(edges: .all)
            VStack{
                HStack{
                    Button{
                        viewModel.coordinator?.closeEditPhoto()
                    }label:{
                        Image(systemName: "xmark")
                            .padding()
                            .font(.title)
                            .foregroundStyle(.white)
                        Spacer()
                    }
                }
                GeometryReader{ proxy in
                    Image(uiImage: viewModel.image)
                        .resizable()
                        .frame( height: proxy.size.height * 4/5)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 16)
                        )
                }
                
                HStack(alignment: .top){
                    customButton(image: "music.quarternote.3", text: "Music", action: nil)
                    customButton(image: "textformat.alt", text: "Text", action: nil)
                    customButton(image: "photo", text: "overlay", action: nil)
                    customButton(image: "camera.filters", text: "filter", action: {openSheet = true})
                    customButton(image: "slider.horizontal.3", text: "Change", action: nil)
                }
                .padding(.horizontal,20)
                .padding(.vertical, 30)
                
                Spacer()
                HStack{
                    Spacer()
                    Button{
                        viewModel.postStory()
                    } label: {
                        Capsule()
                            .fill(Color.blue)
                            .overlay(
                                HStack(alignment: .center){
                                    Text("Post")
                                        .foregroundStyle(.white)
                                    Image(systemName: "arrowshape.forward.fill")
                                        .foregroundStyle(.white)
                                        .frame(width: 15,height: 15)
                                },
                                alignment: .center
                            )
                    }
                    .padding()
                    .frame(maxWidth: 100, maxHeight: 80)
                }
               
            }
        }
        .sheet(isPresented: $openSheet){
            FilterSheet(image: $viewModel.image, isShown: $openSheet ,originalImage: viewModel.originalImage)
        }
       
        
    }
    func customButton(image: String, text: String, action: (()-> Void)?) -> some View{
        let button = Button{
            (action ?? {})()
        } label: {
            RoundedRectangle(cornerRadius: 5)
                .fill(Color.gray.opacity(0.3))
                .frame(width:60, height:50)
                .overlay (
                    VStack{
                       Image(systemName: image)
                            .resizable()
                            .frame(maxWidth: 15,maxHeight: 15)
                            .foregroundStyle(.white)
                       Text(text)
                            .font(.system(size: 11))
                            .foregroundStyle(.white)
                    }, alignment: .center)
        }
        return button
    }
}

