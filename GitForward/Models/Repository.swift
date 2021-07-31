//
//  Repository.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-28.
//

import Foundation

struct Repository: Codable {
    let id: Int
    let name: String
    let htmlUrl: URL
    let description: String?
    let fork: Bool
    let stargazersCount: Int
    let language: String?
}

extension Repository: Comparable {
    static func < (lhs: Repository, rhs: Repository) -> Bool {
        lhs.stargazersCount < rhs.stargazersCount
    }
}
