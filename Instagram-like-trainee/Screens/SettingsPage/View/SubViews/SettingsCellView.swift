//
//  SettingsCellView.swift
//  Instagram-like-trainee
//
//  Created by  on 3.12.25.
//

import SwiftUI

struct SettingsCellView: View {
    var imageName: String
    var text: String
    init(image: String, text: String) {
        self.imageName = image
        self.text = text
    }
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageName)
            Text(text)
        }
    }
}
