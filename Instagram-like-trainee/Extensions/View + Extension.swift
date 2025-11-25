//
//  View + Extension.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 23.04.24.
//

import SwiftUI
import SnapKit

extension View {

    func injectIn(controller viewController: UIViewController) {
        let controller = UIHostingController(rootView: self)
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.backgroundColor = .clear
        viewController.view.addSubview(controller.view)

        controller.view.snp.makeConstraints { make in
            make.leading.equalTo(viewController.view.snp.leading)
            make.trailing.equalTo(viewController.view.snp.trailing)
            make.top.equalTo(viewController.view.snp.topMargin)
            make.bottom.equalTo(viewController.view.snp.bottomMargin)
        }
    }
}
