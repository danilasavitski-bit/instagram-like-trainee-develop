//
//  StoriesCollectionViewCell.swift
//  TableViewTest
//
//  Created by Mikhail Kalatsei on 09/04/2024.
//

import UIKit
import SDWebImage
import UIView_Shimmer

final class StoriesCollectionViewCell: UICollectionViewCell,ShimmeringViewProtocol {
    
    var didPressStory: ((Int)->Void)?
    var index:Int = 0
    
    private var imageView: UIImageView = {
        let imageView = UIImageView(image: .houseFill)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.text = "name"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    var shimmeringAnimatedItems: [UIView] {
        [
            imageView,
            label,
            gradientView
        ]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(imageName: URL, accountName: String,index:Int) {
        self.index = index
        self.imageView.sd_setImage(with: imageName)
        label.text = accountName
    }

    private func configureUI() {
        contentView.backgroundColor = .systemBackground
        configureGradientView()
        configureImageView()
        configureLabel()
    }

    private func configureGradientView() {
        addSubview(gradientView)
        NSLayoutConstraint.activate([
            gradientView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            gradientView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            gradientView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            gradientView.heightAnchor.constraint(equalTo: gradientView.widthAnchor)
        ])
        gradientView.addCircleGradientBorder(6)
    }

    private func configureImageView() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector (openStories(_:)))
        imageView.addGestureRecognizer(gesture)
        imageView.isUserInteractionEnabled = true
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: gradientView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: gradientView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: gradientView.widthAnchor, multiplier: 0.87),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        imageView.makeRounded()
    }

    private func configureLabel() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            label.heightAnchor.constraint(equalToConstant: 15),
            label.centerXAnchor.constraint(equalTo: self.centerXAnchor)
        ])
    }
    
    @objc func openStories(_ sender: UITapGestureRecognizer) {
        guard let didPressStory else { return }
        print("pressed Story at\(index)")
        didPressStory(index - 1)
    }
}
