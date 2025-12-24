//
//  PhotoCell.swift
//  Instagram-like-trainee
//
//  Created by  on 1.12.25.
//

import UIKit
import UIView_Shimmer
import AVKit
import SDWebImage

final class PhotoCell: UICollectionViewCell, ShimmeringViewProtocol {

    // MARK: - UI Elements
    private let photoCellImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let videoContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.isHidden = true
        return view
    }()

    // MARK: - Video
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    // MARK: - Shimmering
    var shimmeringAnimatedItems: [UIView] {
        [photoCellImageView]
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemBackground
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = videoContainerView.bounds
    }

    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        // Stop and remove video
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        videoContainerView.isHidden = true
        // Reset image
        photoCellImageView.image = nil
    }

    // MARK: - Configure
    func configure(photoImageURL: URL,
                   didPressProfile: @escaping ((_ id: Int) -> Void)) {

        if isVideo(url: photoImageURL) {
            videoContainerView.isHidden = false
            let player = AVPlayer(url: photoImageURL)
            let layer = AVPlayerLayer(player: player)
            layer.videoGravity = .resizeAspectFill

            self.player = player
            self.playerLayer = layer
            videoContainerView.layer.addSublayer(layer)
            player.play()
        } else {
            videoContainerView.isHidden = true
            photoCellImageView.sd_setImage(with: photoImageURL)
        }
    }

    // MARK: - UI Setup
    private func configureUI() {
        addSubview(photoCellImageView)
        addSubview(videoContainerView)

        NSLayoutConstraint.activate([
            // Photo
            photoCellImageView.topAnchor.constraint(equalTo: topAnchor),
            photoCellImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            photoCellImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            photoCellImageView.trailingAnchor.constraint(equalTo: trailingAnchor),

            // Video container
            videoContainerView.topAnchor.constraint(equalTo: topAnchor),
            videoContainerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            videoContainerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            videoContainerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    // MARK: - Video Detection
    func isVideo(url: URL) -> Bool {
        guard url.isFileURL else { return false }

        let videoExtensions: Set<String> = [
            "mp4", "mov", "m4v", "avi", "mkv", "webm"
        ]

        return videoExtensions.contains(url.pathExtension.lowercased())
    }
}
