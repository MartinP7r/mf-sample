//
//  UserServiceMock.swift
//  GitForwardTests
//
//  Created by Martin Pfundmair on 2021-07-28.
//
import Combine
import Foundation
@testable import GitForward

final class UserServiceMock: UserServiceProtocol {

    var callCount = 0
    var responseType: ResponseType = .normal

    let userFixture = User(id: 1, login: "John Doe",
                           avatarUrl: URL(string: "https://some-fake-url.com")!)

    enum ResponseType {
        case normal, withError
    }

    func getUsers(completion: @escaping (_ result: Result<[User], ServiceError>) -> Void) {
        print("CALLED")
        callCount += 1
        switch responseType {
        case .normal:
            print("BLUB", [userFixture])
            completion(.success([userFixture]))
        case .withError:
            completion(.failure(.decoding))
        }
    }
}
