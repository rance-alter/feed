//
//  LoadingTableViewCell.swift
//  feed
//
//  Created by Rance Tsai on 10/8/20.
//

import UIKit
import PureLayout

class LoadingTableViewCell: UITableViewCell {
    let activityIndicator = UIActivityIndicatorView(style: .medium)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupActivityIndicator()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupActivityIndicator() {
        contentView.addSubview(activityIndicator)
        activityIndicator.autoAlignAxis(toSuperviewAxis: .vertical)
        [ALEdge.top, .bottom].forEach {
            activityIndicator.autoPinEdge(toSuperviewMargin: $0)
        }
    }
}
