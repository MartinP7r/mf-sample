//
//  UserListsVM.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-23.
//

import Foundation

class UserListViewModel {

    // MARK: - Properties

    private(set) var users = Box([User]())
    private(set) var state: Box<ViewState> = Box(.idle)

    var userCellViewModels: [UserCellViewModel] {
        users.value.map { UserCellViewModel(user: $0, imageService: imageService) }
    }

    private let gitHubService: GitHubServiceProtocol
    private let imageService: ImageServiceProtocol

    // MARK: - Initialization

    init(gitHubService: GitHubServiceProtocol = GitHubService(),
         imageService: ImageServiceProtocol = ImageService()) {
        self.gitHubService = gitHubService
        self.imageService = imageService
    }

    // MARK: - Intents

    func fetchUsers() {
        state.value = .loading

        gitHubService
            .getUsers { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let users):
                        self.state.value = .idle
                        self.users.value = users
                    case .failure(let error):
                        print("failure")
                        self.state.value = .error(error)
                    }
                }
            }
    }
}
