//
//  ContentMessageView.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 24.04.24.
//

import SwiftUI

struct ContentMessageView: View {
    private let colorGradient = LinearGradient(
        gradient: Gradient(
        colors: [Color.gray.opacity(0.3)]),
        startPoint: .leading, endPoint: .trailing)
    private let grayGradient = LinearGradient(
        gradient: Gradient(
        colors: [Color.purple, Color.blue]),
        startPoint: .leading, endPoint: .trailing)
    var contentMessage: String
    var currentUserID: Int

    var body: some View {
        Text(contentMessage)
            .padding(10)
            .foregroundColor(currentUserID != 0 ? Color.white : Color.black)
            .background(
                currentUserID == 0 ? colorGradient : grayGradient)
            .cornerRadius(18)
    }
}

struct ContentMessageView_Previews: PreviewProvider {
    static var previews: some View {
        ContentMessageView(contentMessage: "Hello there", currentUserID: 0)
    }
}
