//
//  UserListView.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-23.
//

import UIKit

class UserListView: UIView {

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
   /* MEMO: Technically these should be on the ViewController/ViewModel side. However they only do static things
            without any non-view side-effects, so hiding the implementation in the view seems fine.
    */

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

fileprivate extension UserListView {

   // MARK: - View Setup

   func setupView() {
       setupTableView()
       setupActivityIndicator()
   }

   func setupTableView() {
       addSubview(tableView)
       tableView.fillSuperview()
       tableView.accessibilityIdentifier = UID.UserList.tableView
       tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.id)
       tableView.separatorColor = .none
   }

   func setupActivityIndicator() {
       addSubview(activityIndicator)
       activityIndicator.centerInSuperview()
   }

}
