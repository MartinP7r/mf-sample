//
//  UserServiceTests.swift
//  GitForwardTests
//
//  Created by Martin Pfundmair on 2021-07-25.
//

import Combine
import XCTest
@testable import GitForward

class UserServiceTests: XCTestCase {

    // MARK: - Properties

    var sut: GitHubService!
    var subscriptions = Set<AnyCancellable>()
    let testBundle = Bundle(for: UserServiceTests.self)

    // MARK: - Test Lifecycle

    override func setUpWithError() throws {
        try setupSUT()
    }

    override func tearDownWithError() throws {
        sut = nil
        super.tearDown()
    }

    // MARK: - Test Setup

    func setupSUT() throws {
        let url = URL(staticString: "https://api.github.com/users")
        let data = try Data(contentsOf: testBundle.url(forResource: "users.json", withExtension: nil)!)
        URLProtocolMock.testURLs = [url: data]
        sut = GitHubService(session: URLProtocolMock.session())
    }

    func test_get_fetchesUserData() throws {
        let expectation = XCTestExpectation(description: "download User data")

        var users: [User]?

        sut.getUsers { result in
                switch result {
                case .success(let data):
                    users = data
                case .failure(let error): XCTFail("fetch completed with error: \(error)")
                }
                expectation.fulfill()
            }

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(30, users?.count)
        XCTAssertEqual("mojombo", users?.first?.login)
        XCTAssertEqual("https://avatars.githubusercontent.com/u/1?v=4", users?.first?.avatarUrl.absoluteString)
    }

}
