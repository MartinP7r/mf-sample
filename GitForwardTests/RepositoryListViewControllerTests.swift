//
//  UserListViewControllerTests.swift
//  GitForwardTests
//
//  Created by Martin Pfundmair on 2021-07-23.
//

import XCTest
@testable import GitForward

class RepositoryListViewControllerTests: XCTestCase {

    // MARK: - Properties

    var sut: RepositoryListViewController!
    var window: UIWindow!
    var navCon: UINavigationController!
    var mockGitHubService: GitHubServiceMock!

    // MARK: - Test Lifecycle
    override func setUpWithError() throws {
        window = UIWindow()
        mockGitHubService = GitHubServiceMock()
        setupSUT()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockGitHubService = nil
        navCon = nil
        window = nil
        super.tearDown()
    }

    // MARK: - Test Setup

    func setupSUT() {
        sut = RepositoryListViewController(viewModel: .init(user: mockGitHubService.userFixture,
                                                            gitHubService: mockGitHubService))

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
        let viewController = RepositoryListViewController(coder: archiver)
        XCTAssertNil(viewController)
    }

    func test_tableView_isInViewHierarchy() throws {
        loadView()

        let tableView = sut.view.find(subViewWithIdentifier: UID.RepositoryList.tableView)

        XCTAssertNotNil(tableView)
    }

    func test_tableView_hasDelegateAndDataSource() throws {
        loadView()

        XCTAssertNotNil(sut.contentView.tableView.delegate)
        XCTAssertNotNil(sut.contentView.tableView.dataSource)
    }

    func test_viewModelBinding_callsUserService() throws {
        XCTAssertEqual(mockGitHubService.callCount, 0)

        loadView()

        XCTAssertEqual(mockGitHubService.callCount, 1)

        sut.vm.fetchRepositories()

        XCTAssertEqual(mockGitHubService.callCount, 2)
    }

    func test_viewModelBinding_updatesTableView() throws {
        loadView()

        let loadExpectation = expectation(description: "load has finished")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            XCTAssertEqual(self.mockGitHubService.callCount, 1)
            XCTAssertEqual(self.sut.contentView.tableView.numberOfRows(inSection: 0), 22)
            loadExpectation.fulfill()
        }

        wait(for: [loadExpectation], timeout: 1)
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
            self.sut.vm.fetchRepositories()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                XCTAssertEqual(self.sut.vm.state.value, .idle)
                fetchExpectation.fulfill()
            }
        }

        wait(for: [loadExpectation, fetchExpectation], timeout: 5)
    }
}
