//
//  UICollectionView+Extension.swift
//  Instagram-like-trainee
//
//  Created by Mikhail Kalatsei on 11/04/2024.
//

import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T? {
        guard let cell = dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            assertionFailure("unable to dequeue cell with identifier \(T.identifier)")
            return nil
        }
        return cell
    }

    func dequeueReusableSupplementaryView <T: UICollectionReusableView>(
        ofKind kind: String,
        for indexPath: IndexPath) -> T? {
        guard let view = dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: T.identifier,
            for: indexPath) as? T else {
            assertionFailure("unable to dequeue cell with identifier \(T.identifier)")
            return nil
        }
        return view
    }

    func registerWithoutXib(cellClasses: UICollectionViewCell.Type...) {
        cellClasses.forEach({
            register($0.self, forCellWithReuseIdentifier: $0.identifier)
        })
    }
}
