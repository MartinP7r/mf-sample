//
//  UIButton+tap.swift
//  GitForwardTests
//
//  Created by Martin Pfundmair on 2021-07-24.
//

import UIKit

extension UIControl {

    /// Triggers the primary action of the UIControl
    /// E.g. button "tap" (touchUpInside)
    func trigger() {
        sendActions(for: .primaryActionTriggered)
    }
}
