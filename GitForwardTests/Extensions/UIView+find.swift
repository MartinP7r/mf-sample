//
//  UIView+find.swift
//  GitForwardTests
//
//  Created by Martin Pfundmair on 2021-07-24.
//

import UIKit

extension UIView {
    func findButton(withText searchText: String) -> UIButton? {
        return subviews
            .compactMap { $0 as? UIButton ?? $0.findButton(withText: searchText) }
            .filter { $0.titleLabel?.text == searchText }
            .first
    }

    func find<T: UIView>(subViewWithIdentifier identifier: String) -> T? {
        return subviews
            .compactMap { $0.find(subViewWithIdentifier: identifier) ?? $0 }
            .filter { $0.accessibilityIdentifier == identifier }
            .first as? T
    }
}
