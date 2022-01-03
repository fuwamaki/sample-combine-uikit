//
//  UITableView+Addition.swift
//  Sample
//
//  Created by fuwamaki on 2022/01/03.
//

import UIKit

extension UITableView {

    func registerForCell<T>(_: T.Type) where T: UITableViewCell, T: NibLoadable {
        register(T.loadNib(), forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func registerForCell<T>(_: T.Type) where T: UITableViewCell {
        register(T.self, forCellReuseIdentifier: T.defaultReuseIdentifier)
    }

    func dequeueCellForIndexPath<T>(_ indexPath: IndexPath, identifier: String? = nil) -> T where T: UITableViewCell {
        let reuseIdentifier = identifier ?? T.defaultReuseIdentifier
        return dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! T
    }
}
