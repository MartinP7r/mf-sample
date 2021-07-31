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

    private(set) var userInfo: Box<UserInfo?> = Box(nil)
    private(set) var state: Box<ViewState> = Box(.idle)

    var handle: String {
        if let userInfo = userInfo.value {
            return "@\(userInfo.login)"
        } else {
            return ""
        }
    }

    var name: String { userInfo.value?.name ?? "" }

    var followersCount: String {
        if let followers = userInfo.value?.followers {
            return "\(followers) follower\(followers == 1 ? "":"s")"
        } else {
            return ""
        }
    }

    var followingCount: String {
        if let following = userInfo.value?.following {
            return "\(following) following"
        } else {
            return ""
        }
    }

    init(user: User,
         gitHubService: GitHubService = .init(),
         imageService: ImageServiceProtocol = ImageService()) {
        self.user = user
        self.gitHubService = gitHubService
        self.imageService = imageService
    }

//    TODO: this should be a cached image since already fetched in UserList
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
                        self.userInfo.value = userInfo
                    case .failure(let error):
                        self.state.value = .error(error)
                    }
                }
            }
    }
}
