//
//  UIImageView + Extension.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 10/04/2024.
//

import UIKit

extension UIView {
    static var identifier: String {
        String(describing: self) //???
    }

    func makeRounded() {
        layoutIfNeeded()
        layer.cornerRadius = layer.frame.width / 2
        clipsToBounds = true
    }

    func addCircleGradientBorder(_ width: CGFloat) { // разбил бы на несколько функций ( создание градиента и создание формы)
        layoutIfNeeded()
        let gradient = CAGradientLayer()
        let size = CGSize(width: frame.width + 10, height: frame.height + 10)
        gradient.frame =  CGRect(origin: CGPoint.zero, size: size)
        let colors: [CGColor] = [
            R.color.gradientOrange()!.cgColor,
            R.color.gradientRed()!.cgColor,
            R.color.gradientPink()!.cgColor,
            R.color.gradientPurple()!.cgColor
        ]
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1, y: 0.5)

        let cornerRadius = frame.size.width / 2
        layer.cornerRadius = cornerRadius
        clipsToBounds = true

        let shape = CAShapeLayer()
        let path = UIBezierPath(ovalIn: bounds)

        shape.lineWidth = width
        shape.path = path.cgPath
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.clear.cgColor
        gradient.mask = shape
        layer.addSublayer(gradient)
    }
}
