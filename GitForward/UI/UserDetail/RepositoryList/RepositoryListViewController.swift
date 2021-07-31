//
//  RepositoryListViewController.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-30.
//

import UIKit

class RepositoryListViewController: ViewController {

    // MARK: - Properties

    let vm: RepositoryListViewModel

    // MARK: - View Elements
    var contentView: RepositoryListView!

    // MARK: - Initialization

    init(viewModel: RepositoryListViewModel, view: RepositoryListView = .init()) {
        self.contentView = view
        self.vm = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    // TODO: move to other ViewController
//    func setupChildViewController() {
//        let child = UserInfoViewController(viewModel: .init(user: ))
//    }

    required init?(coder aDecoder: NSCoder) { return nil }

    // MARK: - ViewController LifeCycle

    override func loadView() {
        view = contentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupBinding()

//        vm.fetchUserInfo()
        vm.fetchRepositories()
    }
}

fileprivate extension RepositoryListViewController {

    // MARK: - View Setup

    func setupView() {
        setupTableView()
        setupNavigationBar()
    }

    func setupTableView() {
        contentView.tableView.delegate = self
        contentView.tableView.dataSource = self
    }

    func setupNavigationBar() {
        navigationItem.title = vm.navBarTitle
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
//        vm.users.bind { [weak self] _ in
//            guard let self = self else { return }
//            self.contentView.tableView.reloadSections([0], with: .automatic)
//        }
        vm.repositories.bind { [weak self] _ in
            self?.contentView.tableView.reloadSections([0], with: .automatic)
        }
    }

    /// Bindings from the view to the viewModel
//    @objc func viewBinding() {
//        vm.fetchUserDetail()
//        vm.fetchUserRepositories()
//    }

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

// MARK: - TableView
extension RepositoryListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return vm.repositoryCellViewModels.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Repositories"
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell: RepositoryCell = tableView
                .dequeueReusableCell(withIdentifier: RepositoryCell.id,
                                     for: indexPath) as? RepositoryCell else { return UITableViewCell() }

        let cellVM = vm.repositoryCellViewModels[indexPath.row]
        cell.configureWith(viewModel: cellVM)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellVM = vm.repositoryCellViewModels[indexPath.row]
        // open webView
    }
}
