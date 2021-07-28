//
//  URL+staticString.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-24.
//

import Foundation

public extension URL {

    /// Initialize a URL from a static string that is guaranteed to produce a valid URL
    /// - Parameter string: static string representing a valid URL
    init(staticString string: StaticString) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid static URL string: \(string)")
        }
        self = url
    }
}
