//
//  UITableViewCell+Addition.swift
//  Sample
//
//  Created by fuwamaki on 2022/01/03.
//

import UIKit

extension UITableViewCell {

    static var defaultHeight: CGFloat {
        return 48.0
    }

    class var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
