//
//  AddStoryCollectionViewCell.swift
//  TableViewTest
//
//  Created by Mikhail Kalatsei on 09/04/2024.
//

import UIKit
import UIView_Shimmer

final class AddStoryCollectionViewCell: UICollectionViewCell,ShimmeringViewProtocol {

    private let profileImageView: UIImageView = {
        let imageView = UIImageView(image: .houseFill)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let plusSignImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "plus.circle.fill") )
        imageView.backgroundColor = .white
        imageView.tintColor = .systemBlue
        imageView.layer.borderColor = .none
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    var shimmeringAnimatedItems: [UIView] {
        [
            profileImageView,
            plusSignImageView,
        ]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    func configure(imageURL: URL) {
        self.profileImageView.sd_setImage(with: imageURL)
        profileImageView.makeRounded()
        layoutIfNeeded()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        contentView.backgroundColor = .systemBackground
        configureProfileImageView()
        configurePlusSignImageView()
    }

    private func configureProfileImageView() {
        addSubview(profileImageView)
        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.65),
            profileImageView.heightAnchor.constraint(equalTo: profileImageView.widthAnchor)
        ])
    }

    private func configurePlusSignImageView() {
        plusSignImageView.makeRounded()
        addSubview(plusSignImageView)
        NSLayoutConstraint.activate([
            plusSignImageView.centerXAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: -10),
            plusSignImageView.centerYAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: -10),
            plusSignImageView.widthAnchor.constraint(equalTo: profileImageView.widthAnchor, multiplier: 0.35),
            plusSignImageView.heightAnchor.constraint(equalTo: plusSignImageView.widthAnchor)
        ])
    }
}
