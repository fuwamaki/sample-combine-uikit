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

// MARK: Combline
extension UITableView {
    func items<Element>(
        _ builder: @escaping (UITableView, IndexPath, Element) -> UITableViewCell
    ) -> ([Element]) -> Void {
        let dataSource = CombineTableViewDataSource(builder: builder)
        return { items in
            dataSource.pushElements(items, to: self)
        }
    }
}

class CombineTableViewDataSource<Element>: NSObject, UITableViewDataSource {
    let build: (UITableView, IndexPath, Element) -> UITableViewCell
    var elements: [Element] = []

    init(builder: @escaping (UITableView, IndexPath, Element) -> UITableViewCell) {
        build = builder
        super.init()
    }

    func pushElements(_ elements: [Element], to tableView: UITableView) {
        tableView.dataSource = self
        self.elements = elements
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        build(tableView, indexPath, elements[indexPath.row])
    }
}
