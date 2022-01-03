//
//  MainViewController.swift
//  Sample
//
//  Created by fuwamaki on 2022/01/03.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.registerForCell(MainTableCell.self)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
