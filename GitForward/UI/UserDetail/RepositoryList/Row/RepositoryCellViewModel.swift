//
//  RepositoryCellViewModel.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-30.
//

import Foundation

struct RepositoryCellViewModel {

    private let repo: Repository

    var name: String { repo.name }
    var language: String { repo.language ?? "" }
    var starsCount: String { "⭐️ \(repo.stargazersCount)" }
    var description: String { repo.description ?? "" }

    init(repo: Repository) {
        self.repo = repo
    }
}
