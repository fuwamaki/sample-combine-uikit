//
//  MainViewModel.swift
//  Sample
//
//  Created by fuwamaki on 2022/01/03.
//

import Foundation

protocol MainViewModelable {
    func fetch(query: String?)
}

final class MainViewModel {

    @Published var list: [GithubRepo] = []

    private let apiClient: APIClientable

    convenience init() {
        self.init(apiClient: APIClient())
    }

    init(apiClient: APIClientable) {
        self.apiClient = apiClient
    }

    @MainActor private func setupList(_ list: [GithubRepo]) {
        self.list = list
    }
}

// MARK: MainViewModelable
extension MainViewModel: MainViewModelable {
    func fetch(query: String?) {
        guard let query = query else { return }
        Task {
            let list = try await apiClient.fetchGithubRepo(query: query).items
            await self.setupList(list)
        }
    }
}
