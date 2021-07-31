//
//  GitHubService.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-23.
//

import Foundation

enum ServiceError: Error { case
    //    unexpected(Error),
    apiError(Error),
    noData,
    decoding
}
extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        //        case .unexpected(let error): return "An unexpected error occurred: \(error.localizedDescription)"
        case .apiError(let error): return "The server returned an error: \(error.localizedDescription)"
        case .decoding: return "Failed to decode data received from server"
        case .noData: return "The server response did not contain any data"
        }
    }
}

protocol GitHubServiceProtocol {
    func getUsers(completion: @escaping (_ result: Result<[User], ServiceError>) -> Void)
    func getUserRepos(user: User, completion: @escaping (_ result: Result<[Repository], ServiceError>) -> Void)
    func getUserInfo(user: User, completion: @escaping (_ result: Result<UserInfo, ServiceError>) -> Void)
}

final class GitHubService: GitHubServiceProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder

    enum Endpoint { case
        users,
        userInfo(login: String),
        repositories(login: String)
    }

    init(session: URLSession = .shared, decoder: JSONDecoder = .snakeCase) {
        self.session = session
        self.decoder = decoder
    }

    func getUsers(completion: @escaping (_ result: Result<[User], ServiceError>) -> Void) {
        fetch(request: request(.users), completion: completion)
    }

    func getUserInfo(user: User,
                     completion: @escaping (_ result: Result<UserInfo, ServiceError>) -> Void) {
        fetch(request: request(.userInfo(login: user.login)), completion: completion)
    }

    func getUserRepos(user: User,
                      completion: @escaping (_ result: Result<[Repository], ServiceError>) -> Void) {
        fetch(request: request(.repositories(login: user.login)), completion: completion)
    }

    private func request(_ endpoint: Endpoint) -> URLRequest {
        var url = URL(staticString: "https://api.github.com/users")

        switch endpoint {
        case .users: break
        case .userInfo(let login):
            url.appendPathComponent(login)
        case .repositories(let login):
            url = url
                .appendingPathComponent(login)
                .appendingPathComponent("repos")
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10.0
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = [
            "Accept": "application/vnd.github.v3+json",
            "Authorization": "Bearer \(Env.variable(.apiKey))"
        ]
        return urlRequest
    }

    private func fetch<M: Codable>(request: URLRequest,
                                   completion: @escaping (_ result: Result<M, ServiceError>) -> Void) {
        session
            .dataTask(with: request) { data, _, error in
                guard error == nil else {
                    return completion(.failure(.apiError(error!)))
                }

                guard let data = data else { return completion(.failure(.noData)) }

                let decoder = JSONDecoder.snakeCase

                do {
                    let decodedData = try decoder.decode(M.self, from: data)
                    return completion(.success(decodedData))
                } catch {
                    print(error)
                    return completion(.failure(.decoding))
                }
            }.resume()
    }
}