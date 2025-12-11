//
//  MyProfileViewController.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 03/04/2024.
//

import UIKit
import Combine
import Photos

class CreatePostViewController: UIViewController {
    
    let viewModel: CreatePostViewModel
    let  collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    var cancellables: Set<AnyCancellable> = []
    var header:PhotoPreviewHeader?
    
    init(viewModel: CreatePostViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        setupCollectionView()
        setupButtons()
        bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        // Do any additional setup after loading the view.
    }
    private func bindData(){
        viewModel.$currentPhoto.receive(on: DispatchQueue.main).sink { [weak self] _ in
            self?.header?.configure(with: self?.viewModel.currentPhoto)
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
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupButtons(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Next",
            style: .plain,
            target: self,
            action: #selector(didTapPost)
        )
    }
    
    @objc private  func didTapPost(){
        print("Post tapped")
    }

}
extension CreatePostViewController: UICollectionViewDataSource {
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
            header.configure(with: viewModel.currentPhoto)
            self.header = header
        return header
    }

    
}
extension CreatePostViewController: UICollectionViewDelegateFlowLayout {
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
            {}()
        default:
            viewModel.currentPhoto = viewModel.photos[indexPath.row - 1]
        }
    }
}
