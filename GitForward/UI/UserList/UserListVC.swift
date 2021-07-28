//
//  UserListVC.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-22.
//

import UIKit

class UserListVC: ViewController {

    // MARK: - Properties

    let vm: UserListViewModel
//    private var subscriptions = Set<AnyCancellable>()

    // MARK: - View Elements
    var contentView: UserListView!
    lazy var refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: nil, action: nil)

    // MARK: - Initialization

    init(viewModel: UserListViewModel = .init(), view: UserListView = .init()) {
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
        vm.fetchUsers()
    }
}

fileprivate extension UserListVC {

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
        navigationItem.title = "GitHub DM"
        navigationItem.rightBarButtonItem = refreshButton
        refreshButton.accessibilityIdentifier = UID.UserList.reloadButton
    }

    // MARK: - ViewModel Binding

    func setupBinding() {
        bindViewModel()
        bindView()
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
        vm.users.bind { [weak self] _ in
            self?.contentView.tableView.reloadSections([0], with: .automatic)
        }
    }

    /// Bindings from the view to the viewModel
    func bindView() {
        refreshButton.action = #selector(tapped)
    }

    @objc func tapped() {
        // bind vm
    }

    // MARK: - Intents

    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error",
                                                message: error.localizedDescription,
                                                preferredStyle: .alert)

        let alertAction = UIAlertAction(title: "OK", style: .default) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.view.accessibilityIdentifier = UID.UserList.alertView
        alertController.addAction(alertAction)
    }
}

// MARK: - TableView
extension UserListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return vm.users.value.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: UserCell = tableView
                .dequeueReusableCell(withIdentifier: UserCell.id,
                                     for: indexPath) as? UserCell else { return UITableViewCell() }

        let cellVM = vm.userCellVMs[indexPath.row]
        cell.configureWith(viewModel: cellVM)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellVM = vm.userCellVMs[indexPath.row]
//        let detailVC = DetailViewController(viewModel: DetailViewModel(user: cellVM.user))
//        navigationController?.pushViewController(detailVC, animated: true)
    }
}
