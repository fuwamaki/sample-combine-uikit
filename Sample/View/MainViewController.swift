//
//  MainViewController.swift
//  Sample
//
//  Created by fuwamaki on 2022/01/03.
//

import UIKit
import Combine
import SafariServices

class MainViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.registerForCell(MainTableCell.self)
            tableView.delegate = self

            viewModel.listSubject
                .sink(receiveValue: tableView.items { tableView, indexPath, item in
                    let cell = tableView.dequeueCellForIndexPath(indexPath) as MainTableCell
                    cell.render(repo: item)
                    return cell
                })
                .store(in: &subscriptions)
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

    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.frame = CGRect(x: 0, y: 0, width: 64, height: 64)
        indicator.center = self.view.center
        indicator.hidesWhenStopped = true
        indicator.color = UIColor.systemMint
        indicator.isHidden = true
        return indicator
    }()

    private var subscriptions = Set<AnyCancellable>()
    private let viewModel: MainViewModelable = MainViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        view.addSubview(indicator)

        viewModel.isLoadingSubject
            .sink { [weak self] in
                $0
                ? self?.indicator.startAnimating()
                : self?.indicator.stopAnimating()
                self?.indicator.isHidden = !$0
            }
            .store(in: &subscriptions)

        viewModel.showWebViewSubject
            .sink { [weak self] in
                let viewController = SFSafariViewController(url: $0)
                self?.present(viewController, animated: true)
            }
            .store(in: &subscriptions)

        viewModel.errorAlertSubject
            .filter { !$0.isEmpty }
            .sink { [weak self] message in
                let alert = UIAlertController(
                    title: "エラー",
                    message: message,
                    preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
            .store(in: &subscriptions)
    }
}

// MARK: UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MainTableCell.defaultHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.handleDidSelectRowAt(indexPath)
    }
}

// MARK: UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {}

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        Task { await viewModel.fetch(query: searchBar.text) }
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = ""
    }
}
