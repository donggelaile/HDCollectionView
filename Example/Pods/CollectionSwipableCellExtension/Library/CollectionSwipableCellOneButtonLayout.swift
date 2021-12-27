//
//  CollectionSwipableCellOneButtonLayout.swift
//  AviasalesComponents
//
//  Created by Dmitry Ryumin on 22/09/2017.
//  Copyright © 2017 Aviasales. All rights reserved.
//

import Foundation

private let kButtonDefaultTitle = "Delete"

/**
 Simple layout with one swipable button
 **/
@objcMembers
open class CollectionSwipableCellOneButtonLayout: NSObject, CollectionSwipableCellLayout {

    public var action: (() -> Void)?

    public let actionsView = UIView()

    public let button = UIButton(type: .system)

    public let direction: UIUserInterfaceLayoutDirection

    private let buttonWidth: CGFloat
    private let insets: UIEdgeInsets

    private let fullOpenInset: CGFloat

    public func swipingAreaWidth() -> CGFloat {
        return buttonWidth + insets.left + insets.right
    }

    public func swipingAreaInset() -> CGFloat {
        return insets.left - fullOpenInset
    }

    public init(buttonWidth: CGFloat, insets: UIEdgeInsets, direction: UIUserInterfaceLayoutDirection, fullOpenInset: CGFloat = 0 ) {
        self.buttonWidth = buttonWidth
        self.insets = insets
        self.direction = direction
        self.fullOpenInset = fullOpenInset

        button.setTitle(kButtonDefaultTitle, for: .normal)
    }

    open func setupActionsView() {
        actionsView.autoresizingMask = [.flexibleLeftMargin, .flexibleHeight]
        actionsView.addSubview(button)

        button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
    }

    open func layoutActionsView() {
        guard let container = actionsView.superview else {
            return
        }

        let width = container.bounds.width - insets.left - insets.right
        let height = container.bounds.height - insets.top - insets.bottom

        let originX = direction == .leftToRight ? insets.left : insets.right

        actionsView.frame = CGRect(x: originX, y: insets.top, width: width, height: height)

        let fullWidth = swipingAreaWidth() - insets.left - insets.right

        actionsView.alpha = width / fullWidth

        let buttonWidth = actionsView.bounds.width < fullWidth ? fullWidth : actionsView.bounds.width
        button.frame = CGRect(x: actionsView.bounds.width - buttonWidth, y: 0, width: buttonWidth, height: actionsView.bounds.height)
    }

    open func cellDidFullOpen() {
        action?()
    }

    @objc private func buttonAction(_ sender: Any) {
        action?()
    }

    open func hapticFeedbackIsEnabled() -> Bool {
        return true
    }

}
