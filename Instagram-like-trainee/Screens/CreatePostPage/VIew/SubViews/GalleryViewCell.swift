//
//  GalleryViewCell.swift
//  Instagram-like-trainee
//
//  Created by  on 11.12.25.
//

import UIKit
import Photos

class GalleryViewCell: UICollectionViewCell {
    
    private let imageManager = PHCachingImageManager()
    private var requestId: PHImageRequestID?
    private var videoIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "video.square")
        imageView.isHidden = true
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init (frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(imageView)
        addSubview(videoIcon)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor,constant: 1),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 1),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: -1),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -1),
            
            videoIcon.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -1),
            videoIcon.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 1),
            videoIcon.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1/4),
            videoIcon.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1/4)
        ])
    }
    
    func configure(with asset: PHAsset) {
        let size = CGSize(width: bounds.width * UIScreen.main.scale,
                          height: bounds.height * UIScreen.main.scale)

        let options = PHImageRequestOptions()
        options.resizeMode = .fast
        options.deliveryMode = .opportunistic

        requestId = imageManager.requestImage(
            for: asset,
            targetSize: size,
            contentMode: .aspectFill,
            options: options
        ) { [weak self] image, _ in
            self?.imageView.image = image
        }
        switch asset.mediaType {
        case .video:
            videoIcon.isHidden = false
        default:
            return
        }
       }
    override func prepareForReuse() {
            super.prepareForReuse()
            if let requestId = requestId {
                imageManager.cancelImageRequest(requestId)
            }
            imageView.image = nil
            videoIcon.isHidden = true
        }
}
