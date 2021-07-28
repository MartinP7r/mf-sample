//
//  User.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-28.
//

import Foundation

struct User: Codable {
    let id: Int
    let login: String
    let avatarUrl: URL
}
