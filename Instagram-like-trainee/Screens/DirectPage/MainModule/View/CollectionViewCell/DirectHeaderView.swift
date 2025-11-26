//
//  DirectHeaderViewCell.swift
//  Instagram-like-trainee
//
//  Created by Eldar Garbuzov on 12.04.24.
//

import UIKit
import SnapKit

final class DirectHeaderView: UICollectionReusableView {
    private let searchBar: UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = R.string.localizable.searshBarPlaceholder()
        return searchBar
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureSearchBar()
    }
    required init?(coder: NSCoder) {
        fatalError("not implemnted")
    }
    private func configureSearchBar() {
        addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.width.equalToSuperview()
        }
    }
}
