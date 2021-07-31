//
//  UIEdgeInsets+ofSize.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-31.
//

import UIKit

extension UIEdgeInsets {

    init(onAllSides size: CGFloat) {
        self.init(top: size, left: size, bottom: size, right: size)
    }
}
