//
//  DirectNotesViewCell.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 12.04.24.
//

import UIKit
import SnapKit

final class DirectNotesViewCell: UICollectionViewCell {

    private var imageView: UIImageView = {
        let imageView = UIImageView(image: .personCropCircle)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private var gradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private var noteTextView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    private var noteTextViewElement: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    lazy var noteTextViewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray6
        label.text = R.string.localizable.directNotesSampleText()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = R.string.localizable.userNameLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(imageName: String?, accountName: String) {
        if let imageName {
            let image = UIImage(named: imageName)
            imageView.image = image
            imageView.makeRounded()
        }
        label.text = accountName
    }

    private func configureUI() {
        contentView.backgroundColor = .systemBackground
        configureImageView()
        configureLabel()
        configureNoteTextView()
        configureNoteTextViewElement()
        configureNoteTextLabel()
    }

    private func configureImageView() {
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.65),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
        imageView.makeRounded()
    }

    private func configureLabel() {
        addSubview(label)
        NSLayoutConstraint.activate([
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -1),
            label.heightAnchor.constraint(equalToConstant: 15),
            label.centerXAnchor.constraint(equalTo: imageView.centerXAnchor)
        ])
    }

    private func configureNoteTextView() {
        addSubview(noteTextView)
        noteTextView.snp.makeConstraints { make in
            make.width.equalTo(60)
            make.height.equalTo(25)
            make.bottom.equalTo(imageView.snp.top).inset(10)
            make.centerX.equalTo(imageView.snp.centerX)
        }
        noteTextView.layer.cornerRadius = min(bounds.width, bounds.height) / 10
        noteTextView.layer.masksToBounds = true
    }

    private func configureNoteTextViewElement() {
        addSubview(noteTextViewElement)
        noteTextViewElement.snp.makeConstraints { make in
            make.width.equalTo(12)
            make.height.equalTo(12)
            make.top.equalTo(noteTextView.snp.bottom)
            make.centerX.equalTo(noteTextView.snp.centerX).offset(-10)
        }
        noteTextViewElement.makeRounded()
    }

    private func configureNoteTextLabel() {
        noteTextView.addSubview(noteTextViewLabel)
        noteTextViewLabel.snp.makeConstraints { make in
            make.centerX.equalTo(noteTextView.snp.centerX)
            make.centerY.equalTo(noteTextView.snp.centerY)
        }
    }
}
