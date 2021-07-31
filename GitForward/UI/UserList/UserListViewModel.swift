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

    var userCellVMs: [UserCellViewModel] {
        users.value.map { UserCellViewModel(user: $0, imageService: imageService) }
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
                        self.state.value = .idle
                        self.users.value = users
                    case .failure(let error):
                        self.state.value = .error(error)
                    }
                }
            }
    }
}
