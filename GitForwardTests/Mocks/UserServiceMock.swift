//
//  UserServiceMock.swift
//  GitForwardTests
//
//  Created by Martin Pfundmair on 2021-07-28.
//
import Combine
import Foundation
@testable import GitForward

final class GitHubServiceMock: GitHubServiceProtocol {
    func getUserRepos(user: User, completion: @escaping (Result<[Repository], ServiceError>) -> Void) {
        callCount += 1
        switch responseType {
        case .normal:
            completion(.success([]))
        case .withError:
            completion(.failure(.decoding))
        }
    }

    func getUserInfo(user: User, completion: @escaping (Result<UserInfo, ServiceError>) -> Void) {
        callCount += 1
        switch responseType {
        case .normal:
            completion(.success(userInfoFixture))
        case .withError:
            completion(.failure(.decoding))
        }
    }


    var callCount = 0
    var responseType: ResponseType = .normal

    let userFixture = User(id: 1, login: "John Doe",
                           avatarUrl: URL(string: "https://some-fake-url.com")!)

    let userInfoFixture = Bundle.init(for: GitHubServiceTests.self).decode(UserInfo.self,
                                                                           from: "userInfo.json")

    enum ResponseType {
        case normal, withError
    }

    func getUsers(completion: @escaping (_ result: Result<[User], ServiceError>) -> Void) {
        callCount += 1
        switch responseType {
        case .normal:
            completion(.success([userFixture]))
        case .withError:
            completion(.failure(.decoding))
        }
    }
}
