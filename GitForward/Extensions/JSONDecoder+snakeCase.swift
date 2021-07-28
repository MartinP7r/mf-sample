//
//  JSONDecoder+snakeCase.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-25.
//

import Foundation

extension JSONDecoder {
    static let snakeCase: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
}
