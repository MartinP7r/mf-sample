//
//  RepositoryListView.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-30.
//

import UIKit

class RepositoryListView: UIView {

    // MARK: - Properties

    // MARK: - View Elements

    lazy var tableView = UITableView(frame: .zero, style: .plain)
    lazy var activityIndicator = ActivityIndicatorView(style: .whiteLarge)

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) { return nil }

    // MARK: - Actions

    func startLoading() {
        tableView.isUserInteractionEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func finishLoading() {
        tableView.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }
}

// MARK: - Private Methods

fileprivate extension RepositoryListView {

    // MARK: - View Setup

    func setupView() {
        setupTableView()
        setupActivityIndicator()
    }

    func setupTableView() {
        addSubview(tableView)
        tableView.fillSuperview()
        tableView.accessibilityIdentifier = UID.RepositoryList.tableView
        tableView.register(RepositoryCell.self, forCellReuseIdentifier: RepositoryCell.id)
        tableView.separatorColor = .none
    }

    func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
    }

}
