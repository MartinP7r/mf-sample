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

    func configureWith(viewModel: UserCellVM) {
        self.textLabel?.text = viewModel.userHandle

        imageRequest = viewModel.avatarImage { [weak self] image in
            self?.imageView?.image = image
            self?.setNeedsLayout()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        imageRequest?.cancel()
        imageRequest = nil
    }
}

fileprivate extension UserCell {

    // MARK: - View Setup

    func setupView() {
        accessoryType = .disclosureIndicator
//        imageView?.image = UIImage(systemName: "person.fill",
//                                   withConfiguration: UIImage.SymbolConfiguration(pointSize: 32, weight: .heavy))
        imageView?.tintColor = .gray
    }
}
