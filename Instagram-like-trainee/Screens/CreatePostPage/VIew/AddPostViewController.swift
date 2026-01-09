//
//  MyProfileViewController.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 03/04/2024.
//

import UIKit
import Combine
import Photos

class AddPostViewController: UIViewController {
    
    let viewModel: CreatePostViewModel
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    let button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var cancellables: Set<AnyCancellable> = []
    var header:PhotoPreviewHeader?
    
    init(viewModel: CreatePostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupButton()
        setupCollectionView()
    }
    private func bindData(){
        viewModel.$currentMedia.receive(on: DispatchQueue.main).sink { [weak self] _ in
            switch self?.viewModel.currentMedia {
            case .image(let image):
                self?.header?.configure(with: image)
            case .video:
                self?.header?.configure(with: self?.header?.asset)
            default:
                {}()
            }
           
        }.store(in: &cancellables)
        viewModel.$photos.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.collectionView.reloadData()
        }.store(in: &cancellables)
    }
    
    private func setupCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerWithoutXib(
            cellClasses: GalleryViewCell.self, GalleryCameraViewCell.self
         )
        collectionView.register(
            PhotoPreviewHeader.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: PhotoPreviewHeader.identifier)
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: button.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupButton(){
        button.addTarget(self, action: #selector(didTapPost), for: .touchUpInside)
        view.addSubview(button)
        NSLayoutConstraint.activate([
            button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            button.widthAnchor.constraint(equalToConstant: 70)
            ])
    }
    
    @objc private func didTapPost(){
        self.viewModel.coordinator?.openEditPost(with: viewModel.currentMedia!)
    }
}

extension AddPostViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.photos.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.row {
        case 0:
            guard let cell: GalleryCameraViewCell = collectionView.dequeueReusableCell(
                for: indexPath) else {
                return GalleryCameraViewCell()
            }
            return cell
        default:
            guard let cell: GalleryViewCell = collectionView.dequeueReusableCell(
                for: indexPath) else {
                return GalleryViewCell()
            }
            let asset = viewModel.photos[indexPath.row - 1]
            cell.configure(with: asset)
            return cell
        }
        
    }
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath
        ) -> UICollectionReusableView {
        guard let header: PhotoPreviewHeader = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            for: indexPath
        ), kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
            self.header = header
            header.configure(with: header.asset)
        return header
    }

    
}
extension AddPostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: view.frame.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size: CGSize = .init(width: collectionView.frame.width/4, height: collectionView.frame.width/4 )
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            guard let coordinator = viewModel.coordinator else { return }
            coordinator.openCamera()
        default:
            let asset = viewModel.photos[indexPath.row - 1]
            switch asset.mediaType {
            case .image:
                let media = Media.image(image: asset)
                viewModel.currentMedia = media
                self.header?.asset = asset
            case .video:
                viewModel.exportVideo(asset: asset, completion: { [weak self] result in
                    DispatchQueue.main.async {
                        
                        let media = Media.video(url: result!)
                        self?.viewModel.currentMedia = media
                        self?.header?.asset = asset
                    }
                })
            default :
                return
            }
           
        }
    }
}
