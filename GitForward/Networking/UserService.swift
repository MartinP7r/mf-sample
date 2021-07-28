//
//  UserService.swift
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

protocol UserServiceProtocol {
    func getUsers(completion: @escaping (_ result: Result<[User], ServiceError>) -> Void)
}

final class UserService: UserServiceProtocol {

    private let session: URLSession
    private let decoder: JSONDecoder

    init(session: URLSession = .shared, decoder: JSONDecoder = .snakeCase) {
        self.session = session
        self.decoder = decoder
    }

    func getUsers(completion: @escaping (_ result: Result<[User], ServiceError>) -> Void) {
        session
            .dataTask(with: request()) { data, _, error in
                guard error == nil else {
                    return completion(.failure(.apiError(error!)))
                }

                guard let data = data else { return completion(.failure(.noData)) }

                let decoder = JSONDecoder.snakeCase

                guard let users = try? decoder.decode([User].self, from: data) else {
                    return completion(.failure(.decoding))
                }

                return completion(.success(users))
            }.resume()
    }

//    func getUserRepos(user: User, _ completion: @escaping (_ result: Result<[Repository],Error>) -> Void = { _ in }) {
//
//    }

    private func request() -> URLRequest {
        let url = URL(staticString: "https://api.github.com/users")

        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 10.0
        urlRequest.httpMethod = "GET"
        urlRequest.allHTTPHeaderFields = [
            "Accept": "application/vnd.github.v3+json",
            "Authorization": "Bearer \(Env.variable(.apiKey))"
        ]
        return urlRequest
    }
}
