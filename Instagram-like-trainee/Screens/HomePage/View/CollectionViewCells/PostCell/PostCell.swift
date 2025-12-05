//
//  PostCaptionCell.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 20.03.24.
//

import UIKit
import UIView_Shimmer

final class PostCell: UICollectionViewCell, ShimmeringViewProtocol {
    private let postHeaderView = PostHeaderView()
    private let postFooterView = PostFooterView()

    private let likesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = R.string.localizable.likesLabel()
        return label
    }()

    private let commentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = R.string.localizable.commentLabel()
        return label
    }()

    private let postImageView: UIImageView = {
        let imageView = UIImageView(image: .checkmark)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .redraw
        return imageView
    }()
    var shimmeringAnimatedItems: [UIView] {
        [
            likesLabel,
            commentLabel,
            postHeaderView,
            postFooterView,
            postImageView
        ]
    }
            

    override init (frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(
        postImageURL: URL,
        postHeaderImageURL: URL,
        postUserName: String,
        id: Int,
        didPressProfile: @escaping ((_ id: Int) -> Void)) {
        self.postImageView.sd_setImage(with: postImageURL)
        self.postHeaderView.configure(image: postHeaderImageURL, userName: postUserName)
        postHeaderView.postId = id
        postHeaderView.didPressProfile = didPressProfile
    }

    private func configureUI() {
        self.backgroundColor = .systemBackground
        postHeaderView.translatesAutoresizingMaskIntoConstraints = false
        postFooterView.translatesAutoresizingMaskIntoConstraints = false
        configureAbovePictureView()
        configurePostImageView()
        configureUnderPictureView()
        configureLikesLabel()
        configureCommentsLabel()
        layoutIfNeeded()
    }

    private func configureAbovePictureView() {
        addSubview(postHeaderView)
        NSLayoutConstraint.activate([
            postHeaderView.topAnchor.constraint(equalTo: self.topAnchor),
            postHeaderView.heightAnchor.constraint(equalToConstant: 50),
            postHeaderView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            postHeaderView.widthAnchor.constraint(equalTo: self.widthAnchor)])
    }

    private func configurePostImageView() {
        addSubview(postImageView)
        NSLayoutConstraint.activate([
            postImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            postImageView.topAnchor.constraint(equalTo: postHeaderView.bottomAnchor),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor),
            postImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)])
    }

    private func configureUnderPictureView() {
        addSubview(postFooterView)
        NSLayoutConstraint.activate([
            postFooterView.topAnchor.constraint(equalTo: postImageView.bottomAnchor),
            postFooterView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            postFooterView.heightAnchor.constraint(equalToConstant: 50),
            postFooterView.widthAnchor.constraint(equalTo: self.widthAnchor)
            ])
    }

    private func configureLikesLabel() {
        addSubview(likesLabel)
        NSLayoutConstraint.activate([
            likesLabel.topAnchor.constraint(equalTo: postFooterView.bottomAnchor),
            likesLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            likesLabel.widthAnchor.constraint(equalTo: self.widthAnchor ),
            likesLabel.heightAnchor.constraint(equalToConstant: 30)])
    }

    private func configureCommentsLabel() {
        addSubview(commentLabel)
        NSLayoutConstraint.activate([
            commentLabel.topAnchor.constraint(equalTo: likesLabel.bottomAnchor),
            commentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            commentLabel.widthAnchor.constraint(equalTo: self.widthAnchor ),
            commentLabel.heightAnchor.constraint(equalToConstant: 30)])
    }
}
