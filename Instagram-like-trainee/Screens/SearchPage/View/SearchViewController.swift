//
//  MyProfileViewController.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 03/04/2024.
//

import UIKit
import Combine

class SearchViewController: UIViewController {
    
    private let viewModel: SearchViewModelProtocol
    private var cancellabeles: Set<AnyCancellable> = []
    private var isLoading: Bool = true
    
    let searchBar = {
        let search = UISearchBar()
        search.translatesAutoresizingMaskIntoConstraints = false
        search.placeholder = R.string.localizable.searshBarPlaceholder()
        return search
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        setupCollectionView()
        setupConstraints()
    }
    
    init(viewModel: SearchViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        bindData() 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindData() {
        viewModel.dataUpdatedPublisher
            .filter({ value in
                value == true
            })
            .sink{ [weak self] _ in
            Task{
                await MainActor.run {
                    self?.isLoading = false
                    self?.collectionView.reloadData()
                }
            }
        }.store(in: &cancellabeles)
    }
    
    private func setupLayout() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        view.addSubview(collectionView)
        view.addSubview(searchBar)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerWithoutXib(
            cellClasses: PhotoCell.self,
            UserCell.self)
    }
    // MARK: - Creating 1 big & 2x2 small group
    private func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { sectionIndex, env -> NSCollectionLayoutSection? in
            switch sectionIndex {
            case 0:
                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(
                    top: 1,
                    leading: 1,
                    bottom: 1,
                    trailing: 1
                )
                
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .estimated(60))
                
                let group = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize,
                    subitems: [item])
                
                let section = NSCollectionLayoutSection(group: group)
                return section
            default:
                let smallItem = NSCollectionLayoutItem(layoutSize: NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0/2.0),
                    heightDimension: .fractionalHeight(1.0)))
                smallItem.contentInsets = NSDirectionalEdgeInsets(
                    top: 1,
                    leading: 1,
                    bottom: 1,
                    trailing: 1
                )
                let bigItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1.0),
                    heightDimension: .fractionalHeight(1.0))
                let bigItem = NSCollectionLayoutItem(layoutSize: bigItemSize)
                bigItem.contentInsets = NSDirectionalEdgeInsets(
                    top: 1,
                    leading: 1,
                    bottom: 1,
                    trailing: 1
                )
                let largeGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0/3.0),
                        heightDimension: .fractionalHeight(1.0)),
                    subitems: [bigItem])
                let smallGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(1.0),
                        heightDimension: .fractionalHeight(1.0/2.0)),
                    subitems: [smallItem,smallItem])
                let smallGroupCombined = NSCollectionLayoutGroup.vertical(
                    layoutSize: NSCollectionLayoutSize(
                        widthDimension: .fractionalWidth(2.0/3.0),
                        heightDimension: .fractionalHeight(1.0)),
                    subitems: [smallGroup,smallGroup])
                if sectionIndex % 2 == 0 {
                    let mainGroup = NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .absolute(250.0)),
                        subitems: [largeGroup,smallGroupCombined])
                    let section = NSCollectionLayoutSection(group: mainGroup)
                    
                    return section
                } else {
                    let mainGroup = NSCollectionLayoutGroup.horizontal(
                        layoutSize: NSCollectionLayoutSize(
                            widthDimension: .fractionalWidth(1.0),
                            heightDimension: .absolute(250.0)),
                        subitems: [smallGroupCombined,largeGroup])
                    let section = NSCollectionLayoutSection(group: mainGroup)
                    
                    return section
                }
            }
        }
        return layout
    }
}

// MARK: - Extensions
extension SearchViewController: // разделил бы протоколы
    UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.setTemplateWithSubviews(isLoading, animate: true, viewBackgroundColor: .systemBackground)
    }
    
}
extension SearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isLoading {
            return 4
        }
        let numberOfSections = Int(ceil(Double(viewModel.getPostsCount())/5))
        return numberOfSections + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.lookForUsers(name: searchBar.text ?? "").count
        default:
            var isSearchActive: Bool {
                return searchBar.isFirstResponder || !(searchBar.text?.isEmpty ?? true)
            }
            return isSearchActive ? 0 : 5
        }
    }
    // swiftlint:disable all
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            switch indexPath.section {
            case 0:
                guard let cell: UserCell = collectionView.dequeueReusableCell(for: indexPath) else {
                    return UserCell()
                }
                
                let userData = viewModel.lookForUsers(name: searchBar.text ?? "")
                let userImage = userData[indexPath.row].profileImage
                let userName = userData[indexPath.row].name
                let userDescription = userData[indexPath.row].description
                
                cell.configure(image: userImage,
                               userName: userName,
                               description: userDescription,
                               id: userData[indexPath.row].id,
                               didPressProfile: viewModel.didPressProfile)
                return cell
                
            default:
                guard let cell: PhotoCell = collectionView.dequeueReusableCell(
                    for: indexPath)
                else{
                    return PhotoCell()
                }
                
                let postsCount = viewModel.getPostsCount()
                let globalCellIndex = indexPath.section * 5 + indexPath.row - 5
                
                guard postsCount > globalCellIndex
                else {
                    return cell
                }
                
                guard  let post = viewModel.getPostDataById(viewModel.getPostsIdByTime()[indexPath.section * 5 + indexPath.row - 5])
                else {
                    return cell
                }
                cell.configure(
                    photoImageURL: post.firstPhotoURL,
                    didPressProfile: {_ in},
                )
                return cell
            }
            
        }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.collectionView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        print("clicked")
        self.collectionView.reloadData()
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.collectionView.reloadData()
        searchBar.setShowsCancelButton(true, animated: true)
    }
}
// swiftlint:enable all
