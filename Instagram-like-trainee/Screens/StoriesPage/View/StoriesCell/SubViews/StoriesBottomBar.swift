//
//  StoriesBottomBar.swift
//  Instagram-like-trainee
//
//  Created by  on 23.12.25.
//

import SwiftUI

struct StoriesBottomBar: View {
    @Binding var isStopped: Bool
    var body: some View {
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
        }
    }
}
