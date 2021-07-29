//
//  UserCellVM.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-23.
//

import Foundation
import UIKit.UIImage

class UserCellVM {

    let user: User
    private let imageService: ImageServiceProtocol

    init(user: User, imageService: ImageServiceProtocol) {
        self.user = user
        self.imageService = imageService
    }

    var userHandle: String { "@\(user.login)" }

    func avatarImage(completion: @escaping (UIImage?) -> Void) -> Cancellable {
        imageService.getImage(for: user.avatarUrl, completion: completion)
    }
}
