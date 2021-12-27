//
//  UICollectionViewCell+CollectionSwipableCellExtension.swift
//  AviasalesComponents
//
//  Created by Dmitry Ryumin on 30/01/2018.
//  Copyright © 2018 Aviasales. All rights reserved.
//

import UIKit

private var kSwipableHandlerAssociatedKey = "swipableHandler"

public extension UICollectionViewCell {

    /**
     * Call this method in collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) of UICollectionViewDelegate of UITableViewDelegate
     **/
    @objc func resetSwipableActions() {
        swipableHandlerWrapper?.handler?.removeCurrentLayouterBeforeCellReusing()
    }

    internal var swipableHandlerWrapper: SwipableHandlerWrapper? {
        set {
            objc_setAssociatedObject(self, &kSwipableHandlerAssociatedKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &kSwipableHandlerAssociatedKey) as? SwipableHandlerWrapper
        }
    }

}
