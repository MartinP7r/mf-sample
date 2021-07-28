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
    private(set) var state: Box<State> = Box(.idle)

    var userCellVMs: [UserCellVM] {
        users.value.map { UserCellVM(user: $0, imageService: imageService) }
    }

    private let userService: UserServiceProtocol
    private let imageService: ImageServiceProtocol

    // MARK: - Initialization

    init(userService: UserServiceProtocol = UserService(),
         imageService: ImageServiceProtocol = ImageService()) {
        self.userService = userService
        self.imageService = imageService
    }

    // MARK: - Intents

    func fetchUsers() {
        state.value = .loading

        userService
            .getUsers { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let users):
                        self.users.value = users
                        self.state.value = .idle
                    case .failure(let error):
                        self.state.value = .error(error)
                    }
                }
            }
    }
}

extension UserListViewModel {
    enum State: Equatable { case
        idle,
        loading,
        error(Error)

        static func == (lhs: UserListViewModel.State, rhs: UserListViewModel.State) -> Bool {
            switch (lhs, rhs) {
            case (.idle, .idle): return true
            case (.loading, .loading): return true
            case (.error, .error): return true // status is considered equal even if the associated errors are not
            default: return false
            }
        }
    }
}
