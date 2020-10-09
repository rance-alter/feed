//
//  StoryTableViewCell.swift
//  feed
//
//  Created by Rance Tsai on 10/4/20.
//

import UIKit
import PureLayout

final class StoryTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .footnote)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTitleLabel()
        setupSubtitleLabel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.autoPinEdges(toSuperviewMarginsExcludingEdge: .bottom)
    }

    private func setupSubtitleLabel() {
        contentView.addSubview(subtitleLabel)
        subtitleLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 8)
        subtitleLabel.autoPinEdges(toSuperviewMarginsExcludingEdge: .top)
    }

    func configure(with viewModel: StoryTableViewCellViewModelProtocol) {
        titleLabel.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}
