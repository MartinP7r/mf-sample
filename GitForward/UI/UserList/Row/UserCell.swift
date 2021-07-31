//
//  UserCell.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-23.
//

import UIKit

class UserCell: UITableViewCell {

    // MARK: - Properties

    static var id: String { String(describing: self) }
    private var imageRequest: Cancellable?

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) { return nil }

    // MARK: - Configuration

    func configureWith(viewModel: UserCellViewModel) {
        self.textLabel?.text = viewModel.userHandle

        imageRequest = viewModel.avatarImage { [weak self] image in
            self?.imageView?.image = image
            self?.setNeedsLayout()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        if let imageView = imageView {
            imageView.image = UIColor.white.image(imageView.frame.size)
        }
        imageRequest?.cancel()
        imageRequest = nil
    }
}

fileprivate extension UserCell {

    // MARK: - View Setup

    func setupView() {
        if let imageView = imageView {
            imageView.image = UIColor.white.image(.init(width: 44, height: 44))
        }
        accessoryType = .disclosureIndicator
    }
}
