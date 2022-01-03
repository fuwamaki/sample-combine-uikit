//
//  MainTableCell.swift
//  Sample
//
//  Created by fuwamaki on 2022/01/03.
//

import UIKit

class MainTableCell: UITableViewCell {

    @IBOutlet private weak var iconImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!

    private var iconImageUrl: String? {
        didSet {
            guard let urlString = iconImageUrl,
                  let url = URL(string: urlString) else { return }
            Task {
                let data = try await apiClient.fetchImageData(url: url)
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.iconImageView.image = image
                }
            }
        }
    }

    private var title: String? {
        didSet {
            titleLabel.text = title
        }
    }

    private var subTitle: String? {
        didSet {
            subTitleLabel.text = "☆ " + (subTitle ?? "")
        }
    }

    private let apiClient: APIClientable = APIClient()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    public func render(repo: GithubRepo) {
        iconImageUrl = repo.owner.avatarUrl
        title = repo.fullName
        subTitle = String(repo.stargazersCount)
    }
}

// MARK: NibLoadable
extension MainTableCell: NibLoadable {}
