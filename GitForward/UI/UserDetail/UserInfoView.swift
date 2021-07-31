//
//  UserInfoView.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-30.
//

import UIKit

class UserInfoView: UIView {

    // MARK: - Properties

    private let vm: UserInfoViewModel
    private var imageRequest: Cancellable?

    // MARK: - View Elements

    lazy var baseStack = UIStackView()
    lazy var avatarView = UIImageView()
    lazy var handleLabel = UILabel()
    lazy var nameLabel = UILabel()
    lazy var followersLabel = UILabel()
    lazy var followingLabel = UILabel()

    //   lazy var activityIndicator = ActivityIndicatorView(style: .whiteLarge)

    // MARK: - Initialization

    init(viewModel: UserInfoViewModel) {
        self.vm = viewModel
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) { return nil }

    // MARK: - Actions

    //   func startLoading() {
    //       tableView.isUserInteractionEnabled = false
    //       activityIndicator.isHidden = false
    //       activityIndicator.startAnimating()
    //   }
    //
    //   func finishLoading() {
    //       tableView.isUserInteractionEnabled = true
    //       activityIndicator.stopAnimating()
    //   }
}

// MARK: - Private Methods

fileprivate extension UserInfoView {

    // MARK: - View Setup

    func setupView() {
        setupLabels()
        setupAvatarView()
        //       setupTableView()
        //       setupActivityIndicator()
        composeViews()
    }

    func setupLabels() {
        [handleLabel, nameLabel, followersLabel, followingLabel].forEach { label in
            //
        }
        handleLabel.text = vm.handle
        nameLabel.text = vm.name
        followersLabel.text = vm.followersCount
        followingLabel.text = vm.followingCount
    }

    func setupAvatarView() {
        imageRequest = vm.avatarImage { [weak self] image in
            self?.avatarView.image = image
            self?.setNeedsLayout()
        }
    }

    func composeViews() {
        let nameStack = UIStackView()
        nameStack.addArrangedSubview(nameLabel)
        nameStack.addArrangedSubview(handleLabel)
        nameStack.axis = .vertical
        nameStack.distribution = .fill
        nameStack.spacing = 3

        let topStack = UIStackView()
        topStack.addArrangedSubview(avatarView)
        topStack.addArrangedSubview(nameStack)
        topStack.axis = .horizontal
        topStack.distribution = .fillProportionally
        topStack.spacing = 3

        let followStack = UIStackView()
        followStack.addArrangedSubview(followersLabel)
        followStack.addArrangedSubview(followingLabel)
        followStack.axis = .horizontal
        followStack.distribution = .fillEqually
        followStack.spacing = 3

        baseStack.addArrangedSubview(topStack)
        baseStack.addArrangedSubview(followStack)
        baseStack.axis = .vertical
        baseStack.distribution = .fill

        addSubview(baseStack)
        baseStack.fillSuperview()
    }
}
