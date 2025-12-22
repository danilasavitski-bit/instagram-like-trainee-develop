//
//  PostCaptionCell.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 20.03.24.
//

import UIKit
import UIView_Shimmer
import AVKit

final class PostCell: UICollectionViewCell, ShimmeringViewProtocol {
    private let postHeaderView = PostHeaderView()
    private let postFooterView = PostFooterView()
    private var photoService = PhotoLibraryService()
    
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
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private var playerReadyToPlay: Bool = false
    private var pendingPlay: Bool = false
    
    var shimmeringAnimatedItems: [UIView] {
        [
            likesLabel,
            commentLabel,
            postHeaderView,
            postFooterView,
            postImageView
        ]
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        addGestureRecognizer()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
        playerReadyToPlay = false
        pendingPlay = false
    }
    
    func startPlayer() {
        if playerReadyToPlay, let player = player {
            player.play()
        } else {
            pendingPlay = true
        }
    }
    
    func stopPlayer() {
        player?.pause()
    }
    
    func configure(
        postImageURL: URL,
        postHeaderImageURL: URL,
        postUserName: String,
        id: Int,
        didPressProfile: @escaping ((_ id: Int) -> Void)
    ) {
        self.postHeaderView.configure(image: postHeaderImageURL, userName: postUserName)
        self.postHeaderView.postId = id
        self.postHeaderView.didPressProfile = didPressProfile
        
        Task {
            if await isVideo(url: postImageURL) {
                let player = AVPlayer(url: postImageURL)
                let playerLayer = AVPlayerLayer(player: player)
                self.player = player
                self.playerLayer = playerLayer
                self.postImageView.layer.addSublayer(playerLayer)
                playerLayer.frame = self.postImageView.bounds
                
                self.playerReadyToPlay = true
                if self.pendingPlay {
                    player.play()
                    self.pendingPlay = false
                }
            } else {
                do {
                    try await photoService.fetchPhotosFromUrl(url: postImageURL) { [weak self] data in
                        guard let self = self else { return }
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.postImageView.image = image
                        }
                    }
                } catch {
                    print("Failed to fetch image: \(error)")
                }
            }
        }
    }
    
    @objc private func mutePlayer() {
        player?.isMuted.toggle()
    }
    
    private func isVideo(url: URL) async -> Bool {
        let asset = AVURLAsset(url: url)
        do {
            let tracks = try await asset.loadTracks(withMediaType: .video)
            return !tracks.isEmpty
        } catch {
            return false
        }
    }
    
    private func addGestureRecognizer() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(mutePlayer))
        postImageView.addGestureRecognizer(gesture)
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
            postHeaderView.widthAnchor.constraint(equalTo: self.widthAnchor)
        ])
    }

    private func configurePostImageView() {
        addSubview(postImageView)
        NSLayoutConstraint.activate([
            postImageView.widthAnchor.constraint(equalTo: self.widthAnchor),
            postImageView.topAnchor.constraint(equalTo: postHeaderView.bottomAnchor),
            postImageView.heightAnchor.constraint(equalTo: postImageView.widthAnchor),
            postImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor)
        ])
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
            likesLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            likesLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    private func configureCommentsLabel() {
        addSubview(commentLabel)
        NSLayoutConstraint.activate([
            commentLabel.topAnchor.constraint(equalTo: likesLabel.bottomAnchor),
            commentLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 12),
            commentLabel.widthAnchor.constraint(equalTo: self.widthAnchor),
            commentLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
