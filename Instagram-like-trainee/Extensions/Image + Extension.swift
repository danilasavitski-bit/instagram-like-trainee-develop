//
//  Image + Extension.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 30.04.24.
//

import SwiftUI

extension Image {
    enum SystemIcon: String {
        case cameraFill = "camera.fill"
        case mic = "mic"
        case photo = "photo"
        case appGift = "app.gift"
        case paperplaneFill = "paperplane.fill"
    }

    init(_ systemIcon: SystemIcon) {
        self.init(systemName: systemIcon.rawValue)
    }
}
