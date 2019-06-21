//
//  UICollectionView+Rx.swift
//  MovieDB
//
//  Created by cuonghx on 6/20/19.
//  Copyright © 2019 Sun*. All rights reserved.
//

import Foundation

extension Reactive where Base: UICollectionView {
    var deSelectCell: Binder<Void> {
        return Binder(base) { cv, _ in
            let selectedItems = cv.indexPathsForSelectedItems ?? []
            for indexPath in selectedItems {
                cv.deselectItem(at: indexPath, animated: true)
            }
        }
    }
}
