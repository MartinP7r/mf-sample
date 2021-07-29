//
//  UserListVCTests.swift
//  GitForwardTests
//
//  Created by Martin Pfundmair on 2021-07-23.
//

import XCTest
@testable import GitForward

class UserListVCTests: XCTestCase {

    // MARK: - Properties

    var sut: UserListVC!
    var window: UIWindow!
    var navCon: UINavigationController!
    var mockUserService: UserServiceMock!
    var mockImageService: ImageServiceMock!

    // MARK: - Test Lifecycle
    override func setUpWithError() throws {
        window = UIWindow()
        mockUserService = UserServiceMock()
        mockImageService = ImageServiceMock()
        setupSUT()
    }

    override func tearDownWithError() throws {
        sut = nil
        mockImageService = nil
        mockUserService = nil
        navCon = nil
        window = nil
        super.tearDown()
    }

    // MARK: - Test Setup

    func setupSUT() {
        sut = UserListVC(viewModel: .init(userService: mockUserService,
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
        let viewController = UserListVC(coder: archiver)
        XCTAssertNil(viewController)
    }

    func test_tableView_isInViewHierarchy() throws {
        loadView()

        let tableView = sut.view.find(subViewWithIdentifier: UID.UserList.tableView)

        XCTAssertNotNil(tableView)
    }

    func test_tableView_hasDelegateAndDataSource() throws {
        loadView()

        XCTAssertNotNil(sut.contentView.tableView.delegate)
        XCTAssertNotNil(sut.contentView.tableView.dataSource)
    }

    func test_reloadButton_isInViewHierarchy() throws {
        loadView()

        let button = sut.navigationItem.rightBarButtonItem
        XCTAssertEqual(button?.accessibilityIdentifier, UID.UserList.reloadButton)
    }

    func test_viewModelBinding_callsUserService() throws {
        XCTAssertEqual(mockUserService.callCount, 0)

        loadView()

        XCTAssertEqual(mockUserService.callCount, 1)

        sut.vm.fetchUsers()

        XCTAssertEqual(mockUserService.callCount, 2)
    }

    func test_viewModelBinding_updatesTableView() throws {
        loadView()

        let loadExpectation = expectation(description: "load has finished")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            XCTAssertEqual(self.mockUserService.callCount, 1)
            XCTAssertEqual(self.sut.contentView.tableView.numberOfRows(inSection: 0), 1)
            loadExpectation.fulfill()
        }

        wait(for: [loadExpectation], timeout: 0.2)
    }

    func test_userServiceError_changesState() throws {
        mockUserService.responseType = .withError

        XCTAssertEqual(sut.vm.state.value, .idle)

        loadView()

        let loadExpectation = expectation(description: "load has finished")
        let fetchExpectation = expectation(description: "fetch has finished")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            XCTAssertEqual(self.sut.vm.state.value, .error(ServiceError.decoding))
            loadExpectation.fulfill()
            self.mockUserService.responseType = .normal
            self.sut.vm.fetchUsers()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                XCTAssertEqual(self.sut.vm.state.value, .idle)
                fetchExpectation.fulfill()
            }
        }

        wait(for: [loadExpectation, fetchExpectation], timeout: 0.5)
    }
}
