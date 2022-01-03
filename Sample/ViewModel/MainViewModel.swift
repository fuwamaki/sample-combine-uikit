//
//  MainViewModel.swift
//  Sample
//
//  Created by fuwamaki on 2022/01/03.
//

import Foundation
import Combine

protocol MainViewModelable {
    var listSubject: PassthroughSubject<[GithubRepo], Never> { get }
    var isLoadingSubject: PassthroughSubject<Bool, Never> { get }
    func fetch(query: String?)
}

final class MainViewModel {
    var listSubject = PassthroughSubject<[GithubRepo], Never>()
    var isLoadingSubject = PassthroughSubject<Bool, Never>()

    private let apiClient: APIClientable

    convenience init() {
        self.init(apiClient: APIClient())
    }

    init(apiClient: APIClientable) {
        self.apiClient = apiClient
    }

    @MainActor private func setupLoading(_ isLoading: Bool) {
        isLoadingSubject.send(isLoading)
    }

    @MainActor private func setupList(_ list: [GithubRepo]) {
        self.listSubject.send(list)
    }
}

// MARK: MainViewModelable
extension MainViewModel: MainViewModelable {
    func fetch(query: String?) {
        guard let query = query else { return }
        Task {
            await self.setupLoading(true)
            let list = try await apiClient.fetchGithubRepo(query: query).items
            await self.setupList(list)
            await self.setupLoading(false)
        }
    }
}
