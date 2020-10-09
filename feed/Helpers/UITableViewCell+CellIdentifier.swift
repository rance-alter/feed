//
//  UITableViewCell+CellIdentifier.swift
//  feed
//
//  Created by Rance Tsai on 10/9/20.
//

import UIKit

extension UITableViewCell {
    static var cellIdentifier: String {
        String(describing: self)
    }
}
