//
//  PhotoCell.swift
//  Instagram-like-trainee
//
//  Created by  on 1.12.25.
//

import UIKit
import UIView_Shimmer

final class PhotoCell: UICollectionViewCell, ShimmeringViewProtocol {
    
    private let photoCellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .redraw
        return imageView
    }()
    var shimmeringAnimatedItems: [UIView] {
        [
            photoCellImageView
        ]
    }
    override init (frame: CGRect) {
        super.init(frame: .zero)
        self.backgroundColor = .systemBackground
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoCellImageView.image = nil
    }

    func configure(
        photoImageURL: URL,
        didPressProfile: @escaping ((_ id: Int) -> Void)) {
        self.photoCellImageView.sd_setImage(with: photoImageURL)
         
    }

    private func configureUI() {
        configurePhotoCellImageView()
        layoutIfNeeded()
    }

    private func configurePhotoCellImageView() {
        addSubview(photoCellImageView)
        NSLayoutConstraint.activate([
            photoCellImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            photoCellImageView.topAnchor.constraint(equalTo: self.topAnchor),
            photoCellImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            photoCellImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)])
    }

}
