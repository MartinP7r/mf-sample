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
    var language: String {
        guard let language = repo.language else { return "" }
        let indicator: String
        switch language {
        case "Swift": indicator = "🟠"
        case "Objective-C": indicator = "🔵"
        case "Ruby": indicator = "🔴"
        case "JavaScript": indicator = "🟡"
        case "Python": indicator = "🔵"
        case "HTML": indicator = "🔴"
        case "Shell": indicator = "🟢"
        case "CSS": indicator = "🟣"
        default: indicator = "⚪️"
        }

        return "\(indicator) \(language)"
    }
    var starsCount: String { "⭐️ \(repo.stargazersCount)" }
    var description: String { repo.description ?? "" }

    init(repo: Repository) {
        self.repo = repo
    }
}
