//
//  ActivityIndicatorView.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-24.
//

import UIKit

final class ActivityIndicatorView: UIActivityIndicatorView {

    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        setUp()
    }

    required init(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    private func setUp() {
        hidesWhenStopped = true
    }
}
