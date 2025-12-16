//
//  TakePhotoView.swift
//  Instagram-like-trainee
//
//  Created by  on 12.12.25.
//

import SwiftUI
import AVFoundation

struct TakePhotoView: View {
    @ObservedObject var viewModel: TakePhotoViewModel
    var body: some View {
        ZStack{
                CameraPreview(session: viewModel.session)
                    .ignoresSafeArea()
                    .overlay(
                        
                        GeometryReader{ proxy in
                            VStack{
                            Rectangle()
                                .opacity(0.8)
                                .ignoresSafeArea()
                            Rectangle()
                                .opacity(0.001)
                                .frame(width: proxy.size.width, height: proxy.size.width)
                            Rectangle()
                                .opacity(0.8)
                                .ignoresSafeArea()
                                .frame(width: proxy.size.width , height: proxy.size.width * 0.7)
                                .overlay(
                                    Button{
                                        viewModel.takePhoto()
                                    } label: {
                                        Circle()
                                            .stroke(style: StrokeStyle(lineWidth: 4))
                                            .foregroundStyle(.white)
                                            .frame(width: 75, height: 75)
                                            .overlay(
                                                Circle()
                                                    .frame(width: 65, height: 65)
                                                    .foregroundStyle(.gray),
                                                alignment: .center
                                            )
                                    }
                                        .padding(90)
                                    ,alignment: .bottom)
                    }
            })
        }
        .overlay(
            Button{
                viewModel.coordinator!.closeTakePhoto()
            }label:{
                Image(systemName: "xmark")
                    .padding()
                    .font(.title)
                    .foregroundStyle(.white)
            }
            , alignment: .topLeading)
    }
}
