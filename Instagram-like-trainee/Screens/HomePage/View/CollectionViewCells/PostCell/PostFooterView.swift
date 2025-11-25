//
//  PostHeaderView.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 10/04/2024.
//

import UIKit

final class PostFooterView: UIView {
    private let likeButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = .heart
        imageView.tintColor = .label
        return imageView
    }()

    private let commentButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = .message
        imageView.tintColor = .label
        return imageView
    }()

    private let shareButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = .paperplane
        imageView.tintColor = .label
        return imageView
    }()

    private let addFavButtonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = .bookmark
        imageView.tintColor = .label
        return imageView
    }()

    init() {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        configureLikeButtonImageView()
        configureCommentButtonImageView()
        configureShareButtonImageView()
        configureAddFavButtonImageView()
    }

    private func configureLikeButtonImageView() {
        addSubview(likeButtonImageView)
        NSLayoutConstraint.activate([
            likeButtonImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            likeButtonImageView.leadingAnchor.constraint(equalTo: leadingAnchor,
                                                         constant: 12),
            likeButtonImageView.widthAnchor.constraint(equalToConstant: 28),
            likeButtonImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    private func configureCommentButtonImageView() {
        addSubview(commentButtonImageView)
        NSLayoutConstraint.activate([
            commentButtonImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            commentButtonImageView.trailingAnchor.constraint(equalTo: likeButtonImageView.trailingAnchor,
                                                             constant: 48),
            commentButtonImageView.widthAnchor.constraint(equalToConstant: 28),
            commentButtonImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    private func configureShareButtonImageView() {
        addSubview(shareButtonImageView)
        NSLayoutConstraint.activate([
            shareButtonImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            shareButtonImageView.trailingAnchor.constraint(equalTo: commentButtonImageView.trailingAnchor,
                                                           constant: 48),
            shareButtonImageView.widthAnchor.constraint(equalToConstant: 28),
            shareButtonImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    private func configureAddFavButtonImageView() {
        addSubview(addFavButtonImageView)
        NSLayoutConstraint.activate([
            addFavButtonImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            addFavButtonImageView.trailingAnchor.constraint(equalTo: trailingAnchor,
                                                            constant: -12),
            addFavButtonImageView.widthAnchor.constraint(equalToConstant: 28),
            addFavButtonImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }
}
