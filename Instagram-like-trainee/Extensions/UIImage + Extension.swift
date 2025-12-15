//
//  UIImage + Extension.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 28.03.24.
//

import UIKit

extension UIImage {
    static let heart = UIImage(systemName: "heart")
    static let message = UIImage(systemName: "message")
    static let paperplane = UIImage(systemName: "paperplane")
    static let bookmark = UIImage(systemName: "bookmark")
    static let ellipsis = UIImage(systemName: "ellipsis")
    static let camera = UIImage(systemName: "camera")
    static let cameraFill = UIImage(systemName: "camera.fill")
    static let house = UIImage(systemName: "house")
    static let houseFill = UIImage(systemName: "house.fill")
    static let magnifyingglassCircle = UIImage(systemName: "magnifyingglass.circle")
    static let magnifyingglassCircleFill = UIImage(systemName: "magnifyingglass.circle.fill")
    static let plusApp = UIImage(systemName: "plus.app")
    static let plusAppFill = UIImage(systemName: "plus.app.fill")
    static let playRectangle = UIImage(systemName: "play.rectangle")
    static let playRectangleFill = UIImage(systemName: "play.rectangle.fill")
    static let personCropCircle = UIImage(systemName: "person.crop.circle")
    static let personCropCircleFill = UIImage(systemName: "person.crop.circle.fill")
    static let squareAndPencil = UIImage(systemName: "square.and.pencil")
    static let backDirectButton = UIImage(systemName: "chevron.backward")
}

extension UIImage {
    func fixOrientation() -> UIImage {
        if imageOrientation == .up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(in: CGRect(origin: .zero, size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }
}
