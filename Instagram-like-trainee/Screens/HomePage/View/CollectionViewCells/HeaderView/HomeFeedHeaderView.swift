//
//  HomeFeedHeaderCell.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 20.03.24.
//

import UIKit

final class HomeFeedHeaderView: UICollectionReusableView {
    var didPressDirect: (() -> Void)?

    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = R.image.instaLogo()
        return imageView
    }()

    private let heartImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = .heart
        imageView.tintColor = .label
        return imageView
    }()
    // swiftlint:disable all
    private lazy var directButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.addTarget(self, action: #selector(directButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(.message, for: .normal)
        return button
    }()
    // swiftlint:enable all

    override init (frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        configureLogoImageView()
        configureHeartImageView()
        configureDirectButton()
    }

    private func configureLogoImageView() {
        addSubview(logoImageView)
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            logoImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            logoImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            logoImageView.widthAnchor.constraint(equalToConstant: 150)
        ])
    }

    private func configureHeartImageView() {
        addSubview(heartImageView)
        NSLayoutConstraint.activate([
            heartImageView.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            heartImageView.trailingAnchor.constraint(equalTo: logoImageView.trailingAnchor, constant: 150),
            heartImageView.widthAnchor.constraint(equalToConstant: 32),
            heartImageView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    private func configureDirectButton() {
        addSubview(directButton)
        NSLayoutConstraint.activate([
            directButton.centerYAnchor.constraint(equalTo: logoImageView.centerYAnchor),
            directButton.trailingAnchor.constraint(equalTo: heartImageView.trailingAnchor, constant: 54),
            directButton.widthAnchor.constraint(equalToConstant: 32),
            directButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    @objc func directButtonPressed() {
        didPressDirect?()
    }
}
