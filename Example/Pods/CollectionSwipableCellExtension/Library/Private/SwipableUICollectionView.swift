//
//  SwipableUICollectionView.swift
//  SwipableUICollectionView
//
//  Created by Denis Chaschin on 09.06.15.
//  Copyright (c) 2015 aviasales. All rights reserved.
//

import UIKit

class SwipableUICollectionView: SwipableActionsCollection {

    public let view: UIView

    private let collectionView: UICollectionView

    init(collectionView: UICollectionView) {
        self.view = collectionView
        self.collectionView = collectionView
    }

    func indexPathForItem(at location: CGPoint) -> IndexPath? {
        return collectionView.indexPathForItem(at: location)
    }

    func item(at indexPath: IndexPath) -> SwipableActionsItem? {
        if let cell = collectionView.cellForItem(at: indexPath) {
            return SwipableItemForUICollectionView(cell: cell, onIndexPath: indexPath)
        }

        return nil
    }

}

class SwipableItemForUICollectionView: SwipableActionsItem {

    let view: UIView
    let contentView: UIView
    let indexPath: IndexPath

    var linkedViews: [UIView] {
        return [cell.backgroundView, cell.selectedBackgroundView].compactMap { $0 }
    }

    private let cell: UICollectionViewCell

    init(cell: UICollectionViewCell, onIndexPath indexPath: IndexPath) {
        self.view = cell
        self.cell = cell
        self.contentView = cell.contentView
        self.indexPath = indexPath
    }

    func setupSwipableHandler(_ handler: CollectionSwipableCellHandler) {
        cell.swipableHandlerWrapper = SwipableHandlerWrapper(handler: handler)
    }

}
