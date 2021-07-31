//
//  UserDetailViewController.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-31.
//

import UIKit

class UserDetailViewController: ViewController {

    // MARK: - Properties
    private let user: User
    let userInfoViewController: UserInfoViewController
    let repositoryListViewController: RepositoryListViewController

    // MARK: - View Elements

    lazy var stackView = UIStackView()

    // MARK: - Initialization
    init(user: User) {
        self.user = user
        userInfoViewController = UserInfoViewController(viewModel: .init(user: user))
        repositoryListViewController = RepositoryListViewController(viewModel: .init(user: user))
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { return nil }

    // MARK: - ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupChildViewControllers()
    }
}

// MARK: - Private Methods
fileprivate extension UserDetailViewController {

    // MARK: - Setup

    func setupChildViewControllers() {
        addChild(userInfoViewController)
        addChild(repositoryListViewController)

        setupSubViews()

        userInfoViewController.didMove(toParent: self)
        repositoryListViewController.didMove(toParent: self)
    }

    func setupSubViews() {
        stackView.addArrangedSubview(userInfoViewController.view)
        stackView.addArrangedSubview(repositoryListViewController.view)
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0

        view.addSubview(stackView)
        stackView.fillSuperview()

        navigationItem.title = user.login
    }

}
