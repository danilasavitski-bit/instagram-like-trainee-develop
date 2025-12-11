//
//  PhotoPreViewHeader.swift
//  Instagram-like-trainee
//
//  Created by  on 11.12.25.
//

import UIKit
import Photos

class PhotoPreviewHeader: UICollectionReusableView {
    
    private let imageManager = PHCachingImageManager()
    private var requestId: PHImageRequestID?
    
    var imageView: UIImageView = {
        let image: UIImageView = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "cross")
        return image
    }()
    
    override init (frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .black
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
    }
    func configure(with asset: PHAsset?) {
        guard let asset = asset else {
            return
        }
           let size = PHImageManagerMaximumSize

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
       }
}
