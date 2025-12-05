//
//  UserCell.swift
//  Instagram-like-trainee
//
//  Created by  on 1.12.25.
//

import UIKit
import SDWebImage

final class UserCell: UICollectionViewCell {
    var didPressProfile: ((_ id: Int) -> Void)?
    var postId: Int?
    private let userPostPictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .checkmark
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
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
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 11, weight: .light)
        label.text = R.string.localizable.userNameLabel()
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .clear
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(image: URL, userName: String, description: String = "",id: Int, didPressProfile: ((_ id: Int) -> Void)?) {
        self.userPostPictureImageView.sd_setImage(with: image)
        self.userNameLabel.text = userName
        self.descriptionLabel.text = description
        self.postId = id
        self.didPressProfile = didPressProfile
    }
    
    private func configureUI() {
        configureUserPostPictureImageView()
        configureUserNameLabel()
        configureDescriptionLabel()
    }
    
    private func configureUserPostPictureImageView() {
        addSubview(userPostPictureImageView)
        
        NSLayoutConstraint.activate([
            userPostPictureImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            userPostPictureImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            userPostPictureImageView.widthAnchor.constraint(equalToConstant: 40),
            userPostPictureImageView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func configureUserNameLabel() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(openProfile(_:)))
        userNameLabel.addGestureRecognizer(tap)
        userNameLabel.isUserInteractionEnabled = true
        addSubview(userNameLabel)
        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            userNameLabel.leadingAnchor.constraint(equalTo: userPostPictureImageView.trailingAnchor, constant: 8)
        ])
    }
    private func configureDescriptionLabel() {
        addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: userPostPictureImageView.trailingAnchor, constant: 8),
            descriptionLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7)
            
        ])
    }
    @objc func openProfile(_ sender: UITapGestureRecognizer) {
        guard let didPressProfile, let postId else { return }
        didPressProfile(postId)
    }
}
