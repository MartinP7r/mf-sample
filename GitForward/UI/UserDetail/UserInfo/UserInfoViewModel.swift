//
//  UserInfoViewModel.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-30.
//

import Foundation
import UIKit.UIImage

struct UserInfoViewModel {

    private let userInfo: UserInfo
    private let imageService: ImageServiceProtocol

    var handle: String { "@\(userInfo.login)" }
    var name: String { userInfo.name }

    var followersCount: String { "\(userInfo.followers) follower\(userInfo.followers == 1 ? "":"s")" }
    var followingCount: String { "\(userInfo.following) following" }

    init(userInfo: UserInfo, imageService: ImageServiceProtocol) {
        self.userInfo = userInfo
        self.imageService = imageService
    }

//    TODO: this should be a cached image since already fetched in UserList
    func avatarImage(completion: @escaping (UIImage?) -> Void) -> Cancellable {
        imageService.getImage(for: userInfo.avatarUrl, completion: completion)
    }
}
