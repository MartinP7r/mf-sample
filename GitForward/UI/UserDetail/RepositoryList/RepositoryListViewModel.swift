//
//  RepositoryListViewModel.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-30.
//

import Foundation

class RepositoryListViewModel {

    // MARK: - Properties

    private let user: User
    private(set) var userInfo: Box<UserInfo?> = Box(nil)
    private(set) var repositories: Box<[Repository]> = Box([])
    private(set) var state: Box<ViewState> = Box(.idle)

    var navBarTitle: String { "@\(user.login)"}

    var repositoryCellViewModels: [RepositoryCellViewModel] {
        repositories.value.map { RepositoryCellViewModel(repo: $0) }
    }

    private let gitHubService: GitHubServiceProtocol

    // MARK: - Initialization

    init(user: User,
         gitHubService: GitHubServiceProtocol = GitHubService()) {
        self.user = user
        self.gitHubService = gitHubService
    }

    // MARK: - Intents

    func fetchRepositories() {
        state.value = .loading

        gitHubService
            .getUserRepos(user: user) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let repos):
                        self.state.value = .idle
                        self.repositories.value = repos
                            .filter { !$0.fork }
                            .sorted(by: >)
                    case .failure(let error):
                        self.state.value = .error(error)
                    }
                }
            }
    }
}
