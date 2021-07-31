//
//  RepositoryCell.swift
//  GitForward
//
//  Created by Martin Pfundmair on 2021-07-31.
//

import UIKit

class RepositoryCell: UITableViewCell {

    // MARK: - Properties
    static var id: String { String(describing: self) }

    // MARK: - View Elements

    lazy var baseStack = UIStackView()
    lazy var nameLabel = UILabel()
    lazy var starsLabel = UILabel()
    lazy var languageLabel = UILabel()
    lazy var descriptionLabel = UILabel()

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder aDecoder: NSCoder) { return nil }

    // MARK: - Configuration

    func configureWith(viewModel: RepositoryCellViewModel) {
        nameLabel.text = viewModel.name
        starsLabel.text = viewModel.starsCount
        languageLabel.text = viewModel.language
        descriptionLabel.text = viewModel.description
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}

fileprivate extension RepositoryCell {

    // MARK: - View Setup

    func setupView() {
        accessoryType = .disclosureIndicator
        setupLabels()
        composeViews()
    }

    func setupLabels() {
        nameLabel.font = UIFont.preferredFont(forTextStyle: .headline)

        [starsLabel, languageLabel]
            .forEach { $0.font = UIFont.preferredFont(forTextStyle: .subheadline) }

        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
    }

    func composeViews() {
        let middleStack = UIStackView()
        middleStack.addArrangedSubview(starsLabel)
        middleStack.addArrangedSubview(languageLabel)
        middleStack.axis = .horizontal
        middleStack.distribution = .equalSpacing
        middleStack.spacing = 3

        baseStack.addArrangedSubview(nameLabel)
        baseStack.addArrangedSubview(middleStack)
        baseStack.addArrangedSubview(descriptionLabel)
        baseStack.axis = .vertical
        baseStack.spacing = 8
        baseStack.distribution = .fill

        contentView.addSubview(baseStack)

        baseStack.fillSuperview(padding: .init(onAllSides: 8))
    }
}
