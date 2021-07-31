//
//  UserInfoViewModel.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-30.
//

import Foundation
import UIKit.UIImage

class UserInfoViewModel {

    private let user: User
    private let gitHubService: GitHubServiceProtocol
    private let imageService: ImageServiceProtocol

    private var userInfo: UserInfo? = nil {
        didSet {
            guard let userInfo = userInfo else { userInfoFormatted.value = nil; return }
            userInfoFormatted.value = Formatted(userInfo: userInfo, imageService: imageService)
        }
    }
    private(set) var userInfoFormatted: Box<Formatted?> = Box(nil)
    private(set) var state: Box<ViewState> = Box(.idle)

    init(user: User,
         gitHubService: GitHubServiceProtocol = GitHubService(),
         imageService: ImageServiceProtocol = ImageService()) {
        self.user = user
        self.gitHubService = gitHubService
        self.imageService = imageService
    }

//    MEMO: this should refactored with image caching since already fetched in UserList
    func avatarImage(completion: @escaping (UIImage?) -> Void) -> Cancellable {
        imageService.getImage(for: user.avatarUrl, completion: completion)
    }

    // MARK: - Intents

    func fetchUserInfo() {
        state.value = .loading

        gitHubService
            .getUserInfo(user: user) { [weak self] result in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    switch result {
                    case .success(let userInfo):
                        self.state.value = .idle
                        self.userInfo = userInfo
                    case .failure(let error):
                        self.state.value = .error(error)
                    }
                }
            }
    }
}

extension UserInfoViewModel {
    struct Formatted {

        private let userInfo: UserInfo
        private let imageService: ImageServiceProtocol

        init(userInfo: UserInfo,
             imageService: ImageServiceProtocol = ImageService()) {
            self.userInfo = userInfo
            self.imageService = imageService
        }

        var handle: String { "@\(userInfo.login)" }
        var name: String { userInfo.name }
        var followersCount: String { "\(userInfo.followers) follower\(userInfo.followers == 1 ? "":"s")" }
        var followingCount: String { "\(userInfo.following) following" }

        func avatarImage(completion: @escaping (UIImage?) -> Void) -> Cancellable {
            imageService.getImage(for: userInfo.avatarUrl, completion: completion)
        }
    }
}
