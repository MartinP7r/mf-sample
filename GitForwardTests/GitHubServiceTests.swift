//
//  UserServiceTests.swift
//  GitForwardTests
//
//  Created by Martin Pfundmair on 2021-07-25.
//

import Combine
import XCTest
@testable import GitForward

class GitHubServiceTests: XCTestCase {

    // MARK: - Properties

    var sut: GitHubService!
    var subscriptions = Set<AnyCancellable>()
    let testBundle = Bundle(for: GitHubServiceTests.self)
    let testUser = User(id: 1337, login: "MartinP7r", avatarUrl: URL(staticString: "https://some-fake-url.com"))

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
        let userInfoUrl = URL(staticString: "https://api.github.com/users/MartinP7r")
        let userInfoData = try Data(contentsOf: testBundle.url(forResource: "userInfo.json", withExtension: nil)!)
        let repoUrl = URL(staticString: "https://api.github.com/users/MartinP7r/repos")
        let repoData = try Data(contentsOf: testBundle.url(forResource: "repositories.json", withExtension: nil)!)
        URLProtocolMock.testURLs = [url: data, userInfoUrl: userInfoData, repoUrl: repoData]
        sut = GitHubService(session: URLProtocolMock.session())
    }

    func test_getUsers_fetchesUserData() throws {
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

    func test_getUserInfo_fetchesData() throws {
        let expectation = XCTestExpectation(description: "download User data")

        var userInfo: UserInfo?

        sut.getUserInfo(user: testUser) { result in
                switch result {
                case .success(let data):
                    userInfo = data
                case .failure(let error): XCTFail("fetch completed with error: \(error)")
                }
                expectation.fulfill()
            }

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual("MartinP7r", userInfo?.login)
        XCTAssertEqual("https://avatars.githubusercontent.com/u/2669027?v=4", userInfo?.avatarUrl.absoluteString)
    }

    func test_getRepositories_fetchesData() throws {
        let expectation = XCTestExpectation(description: "download User data")

        var repos: [Repository]?

        sut.getUserRepos(user: testUser) { result in
                switch result {
                case .success(let data):
                    repos = data
                case .failure(let error): XCTFail("fetch completed with error: \(error)")
                }
                expectation.fulfill()
            }

        wait(for: [expectation], timeout: 1.0)

        XCTAssertEqual(30, repos?.count)
        XCTAssertEqual("30daysoflaptops.github.io", repos?.first?.name)
        XCTAssertEqual("https://github.com/mojombo/30daysoflaptops.github.io", repos?.first?.htmlUrl.absoluteString)
    }

}
