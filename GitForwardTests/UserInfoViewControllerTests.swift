//
//  UserListViewControllerTests.swift
//  GitForwardTests
//
//  Created by Martin Pfundmair on 2021-07-23.
//

import XCTest
@testable import GitForward

class UserInfoViewControllerTests: XCTestCase {

    // MARK: - Properties

    var sut: UserInfoViewController!
    var window: UIWindow!
    var navCon: UINavigationController!
    var mockGitHubService: GitHubServiceMock!
    var mockImageService: ImageServiceMock!

    // MARK: - Test Lifecycle
    override func setUpWithError() throws {
        window = UIWindow()
        mockGitHubService = GitHubServiceMock()
        mockImageService = ImageServiceMock()
        setupSUT()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockImageService = nil
        mockGitHubService = nil
        navCon = nil
        window = nil
        super.tearDown()
    }

    // MARK: - Test Setup

    func setupSUT() {
        sut = UserInfoViewController(viewModel: .init(user: mockGitHubService.userFixture,
                                                      gitHubService: mockGitHubService,
                                          imageService: mockImageService))

        navCon = UINavigationController(rootViewController: sut)
        window.rootViewController = navCon
    }

    func loadView() {
        // Calls ViewDidLoad
        _ = sut.view
        RunLoop.current.run(until: Date())
        sut.view.setNeedsLayout()
        sut.view.layoutIfNeeded()
        // Calls ViewWillAppear
        sut.beginAppearanceTransition(true, animated: false)
        sut.endAppearanceTransition()
    }

    // MARK: - Tests

    func test_initWithCoder() throws {
        let archiver = NSKeyedArchiver(requiringSecureCoding: true)
        let viewController = UserInfoViewController(coder: archiver)
        XCTAssertNil(viewController)
    }

    func test_viewModelBinding_callsUserService() throws {
        XCTAssertEqual(mockGitHubService.callCount, 0)

        loadView()

        XCTAssertEqual(mockGitHubService.callCount, 1)

        sut.vm.fetchUserInfo()

        XCTAssertEqual(mockGitHubService.callCount, 2)
    }

    func test_userServiceError_changesState() throws {
        mockGitHubService.responseType = .withError

        XCTAssertEqual(sut.vm.state.value, .idle)

        loadView()

        let loadExpectation = expectation(description: "load has finished")
        let fetchExpectation = expectation(description: "fetch has finished")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.sut.vm.state.value, .error(ServiceError.decoding))
            loadExpectation.fulfill()
            self.mockGitHubService.responseType = .normal
            self.sut.vm.fetchUserInfo()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                XCTAssertEqual(self.sut.vm.state.value, .idle)
                fetchExpectation.fulfill()
            }
        }

        wait(for: [loadExpectation, fetchExpectation], timeout: 5)
    }
}
