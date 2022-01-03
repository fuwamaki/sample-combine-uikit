//
//  MainViewController.swift
//  Sample
//
//  Created by fuwamaki on 2022/01/03.
//

import UIKit
import Combine

struct Person {
    let name: String
}

class MainViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.registerForCell(MainTableCell.self)
            tableView.delegate = self
            cancellable = $people
                .sink(receiveValue: tableView.items { tableView, indexPath, item in
                let cell = tableView.dequeueCellForIndexPath(indexPath) as MainTableCell
                cell.textLabel?.text = item.name
                return cell
            })
        }
    }

    @Published var people = [Person(name: "Kim"), Person(name: "Charles")]
    var cancellable: AnyCancellable?

    private let viewModel: MainViewModelable = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MainTableCell.defaultHeight
    }
}
