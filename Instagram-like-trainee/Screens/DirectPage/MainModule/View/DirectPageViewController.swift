//
//  DirectPageViewController.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 8.04.24.
//

import UIKit
import SnapKit

protocol DirectPage {
    var dialogsCount: Int { get }
    var messageCount: Int { get }
    var usersCount: Int { get }
    var messagePreview: String { get }
    func getUserData(id: Int) -> HomeScreenUserData?
    func openDialog(_ id: Int)
}

final class DirectPageViewController: UIViewController {
    private var viewModel: DirectPage
    private var collectionView: UICollectionView = {
        let supItem = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .absolute(50)),
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        let supplementaryViews = [supItem]
        let layout = UICollectionViewCompositionalLayout { sectionIndex, _ -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                    let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0)))
                    item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 1, bottom: 1, trailing: 1)
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .estimated(100),
                            heightDimension: .fractionalHeight(0.14)),
                        subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .continuous
                    section.boundarySupplementaryItems = supplementaryViews
                    return section
            case 1:
                    let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(0.1)))
                    item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
                    let group = NSCollectionLayoutGroup.vertical(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .fractionalWidth(1.4)),
                        subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    return section
            default:
                    let item = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(0.2),
                        heightDimension: .fractionalHeight(0.2)))
                    item.contentInsets = NSDirectionalEdgeInsets(top: 1, leading: 1, bottom: 1, trailing: 1)
                    let group = NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .fractionalHeight(0.3)),
                        subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.orthogonalScrollingBehavior = .continuous
                    return section
            }
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    init(viewModel: DirectPage) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        setupCollectionView()
        setupConstraints()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem( // отступы
            image: .squareAndPencil,
            style: .plain,
            target: self,
            action: #selector(writeToButtonPressed))
        self.navigationItem.leftBarButtonItems = [ // отступы
            UIBarButtonItem(
            image: .backDirectButton,
            style: .plain,
            target: self,
            action: #selector(backActionPressed)),
            UIBarButtonItem(title: R.string.localizable.account(),
            style: .plain,
            target: self,
            action: #selector(changeAccountPressed))
        ]
    }
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }

    private func setupCollectionView() {
        collectionView.registerWithoutXib(
            cellClasses: DirectPageCell.self,
            DirectNotesViewCell.self)
        collectionView.register(
            DirectHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: DirectHeaderView.identifier)
    }

    private func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.top.equalTo(view.snp.topMargin)
            make.bottom.equalTo(view.snp.bottomMargin)
        }
    }

    @objc private func writeToButtonPressed() {
        // TODO: - this method call feature witch able to write to somebody direct message
    }
    @objc private func backActionPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    @objc private func changeAccountPressed() {
        // TODO: - it will show view with possible accounts to change
    }
}

extension DirectPageViewController:
    UICollectionViewDelegate, UICollectionViewDataSource { // разделил бы делегат и датасорс
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
           return viewModel.messageCount
        case 1:
                return viewModel.usersCount
        default:
                return 0
        }
    }
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch indexPath.section {
            case 0:
                    guard let cell: DirectNotesViewCell = collectionView.dequeueReusableCell(
                        for: indexPath) else {
                        return DirectNotesViewCell()
                    }
                    if indexPath.row == 0 {
                        cell.label.text = R.string.localizable.directNotesAccountOwnerText()
                    }
                    return cell
            case 1:
                    guard let cell: DirectPageCell = collectionView.dequeueReusableCell(
                        for: indexPath),
                          let data = viewModel.getUserData(id: indexPath.row)
                    else {
                        return DirectPageCell()
                    }
                    cell.configure(messagePreview: viewModel.messagePreview,
                                   imageName: data.profileImage,
                                   userName: data.name)
                    return cell
            default:
                    return UICollectionViewCell()
            }
        }
    func collectionView(
        _ collectionView: UICollectionView,
        viewForSupplementaryElementOfKind kind: String,
        at indexPath: IndexPath) -> UICollectionReusableView {
            guard let header: DirectHeaderView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                for: indexPath
            ), kind == UICollectionView.elementKindSectionHeader else {
                return UICollectionReusableView()
            }
            header.layer.masksToBounds = true
            return header
        }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
                viewModel.openDialog(indexPath.row)
        default:
               break
        }
    }
}
