//
//  CollectionSwipableCellExtension.swift
//  AviasalesComponents
//
//  Created by Dmitry Ryumin on 22/09/2017.
//  Copyright © 2017 Aviasales. All rights reserved.
//

import Foundation

/**
 Layout of swipable buttons
 **/
@objc
public protocol CollectionSwipableCellLayout: AnyObject {

    /**
     Container view for action buttons
     **/
    var actionsView: UIView { get }

    /**
     Width of opened buttons
     **/
    func swipingAreaWidth() -> CGFloat

    /**
     Swipable buttons inset for case when swipable area has some margin from cell's content
     **/
    func swipingAreaInset() -> CGFloat

    /**
     Initialization of actionsView and its subviews
     **/
    func setupActionsView()

    /**
     Method for set frames of action buttons
     **/
    func layoutActionsView()

    /**
     Call after long swipe when swipable area is fully opened
     **/
    func cellDidFullOpen()

    /**
     Use or not haptic feedback on full open
     **/
    func hapticFeedbackIsEnabled() -> Bool
}

/**
 Swipable extension delegate
 **/
@objc
public protocol CollectionSwipableCellExtensionDelegate: AnyObject {

    /**
     Is needed show swipable buttons in cell on indexPath
     **/
    func isSwipable(itemAt indexPath: IndexPath) -> Bool

    /**
     Return swipable buttons layout for cell on indexPath
     **/
    func swipableActionsLayout(forItemAt indexPath: IndexPath) -> CollectionSwipableCellLayout?

}

@objcMembers
public class CollectionSwipableCellExtension: NSObject {

    /**
     Swipable extension delegate
     **/
    public weak var delegate: CollectionSwipableCellExtensionDelegate? {
        didSet {
            handler?.delegate = delegate
        }
    }

    /**
     Enable/disable swipable functionality
     **/
    public var isEnabled: Bool = false {
        didSet {
            if isEnabled {
                let direction: UIUserInterfaceLayoutDirection = isRtlLayoutDirection(of: collection.view) ? .rightToLeft : .leftToRight
                handler = CollectionSwipableCellHandler(collection: collection, direction: direction)
                handler?.delegate = delegate
                handler?.applyToCollection()
            } else {
                handler?.removeFromCollection()
                handler = nil
            }
        }
    }

    private let collection: SwipableActionsCollection
    private var handler: CollectionSwipableCellHandler?

    /**
     Initialization with UICollectionView
     **/
    @objc(initWithCollectionView:)
    public init(with collectionView: UICollectionView) {
        self.collection = SwipableUICollectionView(collectionView: collectionView)
        super.init()

        startHandlingViewWindow()
    }

    /**
     Initialization with UITableView
     **/
    @objc(initWithTableView:)
    public init(with tableView: UITableView) {
        self.collection = SwipableUITableView(tableView: tableView)
        super.init()

        startHandlingViewWindow()
    }

    // MARK: Handle move out of window

    private class AnchorView: UIView {

        var emptyWindowHandler: (() -> (Void))?

        override func willMove(toWindow newWindow: UIWindow?) {
            super.willMove(toWindow: newWindow)

            if let emptyWindowHandler = emptyWindowHandler, newWindow == nil {
                emptyWindowHandler()
            }
        }

    }

    private func startHandlingViewWindow() {
        let anchorView = AnchorView(frame: .zero)
        anchorView.alpha = 0
        anchorView.emptyWindowHandler = { [weak self] in
            self?.closeAllActions()
        }

        collection.view.addSubview(anchorView)
    }

}

// MARK: Public methods for programmatic control

public extension CollectionSwipableCellExtension {

    /**
     Open actions for cell at specified index path
     **/
    @objc
    func openActionsForCell(at indexPath: IndexPath, animated: Bool = true) {
        handler?.openActionsForCell(at: indexPath, animated: animated)
    }

    /**
     Open actions for cell at specified index path with specified width
     **/
    @objc
    func openActionsForCell(at indexPath: IndexPath, visibleWidth: CGFloat, animated: Bool = true) {
        handler?.openActionsForCell(at: indexPath, customVisibleWidth: visibleWidth, animated: animated)
    }

    /**
     Close opened actions
     **/
    @objc
    func closeAllActions(animated: Bool = true) {
        handler?.closeCellInProgress(animated: animated)
    }
}

internal class SwipableHandlerWrapper {

    private(set) weak var handler: CollectionSwipableCellHandler?

    init(handler: CollectionSwipableCellHandler) {
        self.handler = handler
    }

}

private func isRtlLayoutDirection(of view: UIView) -> Bool {
    if #available(iOS 9.0, *) {
        return UIView.userInterfaceLayoutDirection(for: view.semanticContentAttribute) == .rightToLeft
    } else {
        let lang = Locale.current.languageCode
        return NSLocale.characterDirection(forLanguage: lang!) == .rightToLeft
    }
}
