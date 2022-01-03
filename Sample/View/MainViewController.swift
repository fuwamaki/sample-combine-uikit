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
            cancellable = viewModel.$list
                .sink(receiveValue: tableView.items { tableView, indexPath, item in
                    let cell = tableView.dequeueCellForIndexPath(indexPath) as MainTableCell
                    cell.render(repo: item)
                    return cell
                })
        }
    }

    private lazy var searchController: UISearchController = {
        let controller = UISearchController()
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.delegate = self
        controller.searchBar.tintColor = .systemMint
        controller.searchBar.placeholder = "GithubのQueryを入力"
        return controller
    }()

    @Published var people = [Person(name: "Kim"), Person(name: "Charles")]
    var cancellable: AnyCancellable?

//    private let viewModel: MainViewModelable = MainViewModel()
    private let viewModel = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
}

// MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MainTableCell.defaultHeight
    }
}

// MARK: UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {}

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.fetch(query: searchBar.text)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
    }
}
