//
//  UserInfoViewController.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-31.
//

import UIKit

class UserInfoViewController: UIViewController {

    // MARK: - Properties

    let vm: UserInfoViewModel

    // MARK: - View Elements
    var contentView: UserInfoView!

    // MARK: - Initialization

    init(viewModel: UserInfoViewModel, view: UserInfoView = .init()) {
        self.contentView = view
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) { return nil }

    // MARK: - ViewController LifeCycle

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()

        vm.fetchUserInfo()
    }
}

fileprivate extension UserInfoViewController {

    // MARK: - View Setup

    func setupView() {
        setupNavigationBar()
    }

    func setupNavigationBar() {
//        navigationItem.title = vm.navBarTitle
    }

    // MARK: - ViewModel Binding

    func setupBinding() {
        bindViewModel()
//        bindView()
    }

    /// Bindings from the viewModel to the view
    func bindViewModel() {
        vm.state.bind { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .idle: self.contentView.finishLoading()
            case .loading: self.contentView.startLoading()
            case .error(let error):
                self.showError(error)
                self.contentView.finishLoading()
            }
        }
        
        vm.userInfo.bind { [weak self] userInfo in
            guard let self = self else { return }
            self.contentView.configureWith(self.vm)
        }
    }

    // MARK: - Intents

    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.view.accessibilityIdentifier = UID.UserDetail.alertView
        alertController.addAction(alertAction)
    }
}
