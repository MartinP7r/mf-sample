//
//  UserInfoView.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-30.
//

import UIKit

class UserInfoView: UIView {

    // MARK: - Properties

    private var imageRequest: Cancellable?

    // MARK: - View Elements

    lazy var baseStack = UIStackView()
    lazy var avatarView = UIImageView()
    lazy var handleLabel = UILabel()
    lazy var nameLabel = UILabel()
    lazy var followersLabel = UILabel()
    lazy var followingLabel = UILabel()

    lazy var activityIndicator = ActivityIndicatorView(style: .whiteLarge)

    // MARK: - Initialization

    init() {
        super.init(frame: .zero)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) { return nil }

    // MARK: - Actions

    func startLoading() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }

    func finishLoading() {
        activityIndicator.stopAnimating()
    }

    func configureWith(_ vm: UserInfoViewModel) {

        handleLabel.text = vm.handle
        nameLabel.text = vm.name
        followersLabel.text = vm.followersCount
        followingLabel.text = vm.followingCount

        imageRequest = vm.avatarImage { [weak self] image in
            self?.avatarView.image = image
            self?.setNeedsLayout()
        }
    }
}

// MARK: - Private Methods

fileprivate extension UserInfoView {

    // MARK: - View Setup

    func setupView() {
        setupLabels()
        setupAvatarView()
        setupActivityIndicator()
        composeViews()
    }

    func setupLabels() {
        [handleLabel, nameLabel, followersLabel, followingLabel].forEach { label in
            //
        }
        handleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    }

    func setupAvatarView() {

    }

    func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
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
