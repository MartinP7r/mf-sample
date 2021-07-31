//
//  UIView+Anchors.swift
//
//  Created by Pfundmair Martin on 2018/04/02.
//

import UIKit

extension UIView {

    func fillSuperview(padding: UIEdgeInsets = .zero) {
        anchor(top: superview?.safeTopAnchor,
               leading: superview?.safeLeadingAnchor,
               bottom: superview?.safeBottomAnchor,
               trailing: superview?.safeTrailingAnchor,
               padding: padding)
    }

    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }

    /// Sets the view's layout anchors, padding and size
    ///
    /// This **disables the view's** `translatesAutoresizingMaskIntoConstraints`
    func anchor(top: NSLayoutYAxisAnchor?,
                leading: NSLayoutXAxisAnchor?,
                bottom: NSLayoutYAxisAnchor?,
                trailing: NSLayoutXAxisAnchor?,
                padding: UIEdgeInsets = .zero,
                size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }

        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }

        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }

        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }

        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }

        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }

    func centerInSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        guard let centerX = superview?.centerXAnchor,
            let centerY = superview?.centerYAnchor else { return }
        centerXAnchor.constraint(equalTo: centerX).isActive = true
        centerYAnchor.constraint(equalTo: centerY).isActive = true
    }
}
