//
//  PostHeaderView.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 10/04/2024.
//

import UIKit

final class PostHeaderView: UIView {
    var didPressProfile: ((_ id: Int) -> Void)?
    var postId: Int?
    private let userPostPictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .checkmark
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.systemPink.cgColor
        return imageView
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .semibold)
        label.text = R.string.localizable.userNameLabel()
        return label
    }()

    private let moreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = .ellipsis
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

    func configure(image: URL, userName: String) {
        self.userPostPictureImageView.sd_setImage(with: image)
        self.userNameLabel.text = userName
    }

    private func configureUI() {
        configureUserPostPictureImageView()
        configureUserNameLabel()
        configureMoreImageView()
    }

    private func configureUserPostPictureImageView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openProfile(_:)))
        userPostPictureImageView.addGestureRecognizer(tap)
        userPostPictureImageView.isUserInteractionEnabled = true
        addSubview(userPostPictureImageView)

        NSLayoutConstraint.activate([
            userPostPictureImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            userPostPictureImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            userPostPictureImageView.widthAnchor.constraint(equalToConstant: 32),
            userPostPictureImageView.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    private func configureUserNameLabel() {
        addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            userNameLabel.leadingAnchor.constraint(equalTo: userPostPictureImageView.trailingAnchor, constant: 8)
        ])
    }

    private func configureMoreImageView() {
        addSubview(moreImageView)
        NSLayoutConstraint.activate([
            moreImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            moreImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            moreImageView.widthAnchor.constraint(equalToConstant: 24),
            moreImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }

    @objc func openProfile(_ sender: UITapGestureRecognizer) {
        guard let didPressProfile, let postId else { return }
        didPressProfile(postId)
    }

}
