//
//  DirectPageCell.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 10.04.24.
//

import UIKit
import SnapKit
import SDWebImage
import UIView_Shimmer

final class DirectPageCell: UICollectionViewCell, ShimmeringViewProtocol {
    private let userPostPictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .checkmark
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.text = R.string.localizable.userNameLabel()
        return label
    }()
    
    private let messagePreviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.text = R.string.localizable.messagePreviewLabel()
        return label
    }()
    
    private lazy var cameraButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        button.addTarget(self, action: #selector(cameraButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(.camera, for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .label
        return button
    }()
    var shimmeringAnimatedItems: [UIView] {
        [
            userPostPictureImageView,
            userNameLabel,
            messagePreviewLabel,
            cameraButton
        ]
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    
    func configure(messagePreview: String, imageName: URL, userName: String) {
        messagePreviewLabel.text = messagePreview
        userNameLabel.text = userName
        self.userPostPictureImageView.sd_setImage(with: imageName)
    }
    
    private func configureUI() {
        addSubview(userPostPictureImageView)
        addSubview(userNameLabel)
        addSubview(messagePreviewLabel)
        addSubview(cameraButton)
    }
    
    private func setupConstraints() {
        userPostPictureImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(42)
            make.height.equalTo(42)
        }
        userNameLabel.snp.makeConstraints { make in
            make.leading.equalTo(userPostPictureImageView).inset(52)
            make.top.equalTo(0)
            make.width.equalTo(128)
            make.height.equalTo(32)
        }
        messagePreviewLabel.snp.makeConstraints { make in
            make.leading.equalTo(userPostPictureImageView).inset(52)
            make.top.equalTo(userNameLabel).inset(20)
            make.width.equalTo(256)
            make.height.equalTo(32)
        }
        cameraButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.equalTo(24)
            make.height.equalTo(20)
        }
    }
    
    @objc private func cameraButtonPressed() {
    }
}
