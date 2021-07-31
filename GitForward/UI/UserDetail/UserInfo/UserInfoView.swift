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

    func configureWith(_ vm: UserInfoViewModel.Formatted?) {
        guard let vm = vm else { return }

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
        handleLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    }

    func setupAvatarView() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        avatarView.widthAnchor.constraint(equalTo: avatarView.heightAnchor, multiplier: 1).isActive = true
        avatarView.heightAnchor.constraint(equalToConstant: 88).isActive = true
        avatarView.layer.cornerRadius = 8
        avatarView.clipsToBounds = true
    }

    func setupActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.centerInSuperview()
    }

    func composeViews() {
        let followStack = UIStackView()
        followStack.addArrangedSubview(followersLabel)
        followStack.addArrangedSubview(followingLabel)
        followStack.axis = .horizontal
        followStack.distribution = .fillEqually
        followStack.spacing = 8

        let spacer = UIView()
        spacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        let nameStack = UIStackView()
        nameStack.addArrangedSubview(nameLabel)
        nameStack.addArrangedSubview(handleLabel)
        nameStack.addArrangedSubview(spacer)
        nameStack.addArrangedSubview(followStack)
        nameStack.axis = .vertical
        nameStack.distribution = .fill
        nameStack.spacing = 8

        baseStack.addArrangedSubview(avatarView)
        baseStack.addArrangedSubview(nameStack)
        baseStack.axis = .horizontal
        baseStack.distribution = .fill
        baseStack.spacing = 8

        addSubview(baseStack)
        baseStack.fillSuperview(padding: .init(onAllSides: 8))
    }
}
