//
//  MainViewModel.swift
//  Sample
//
//  Created by fuwamaki on 2022/01/03.
//

import Foundation
import Combine

protocol MainViewModelable {
    var listSubject: CurrentValueSubject<[GithubRepo], Never> { get }
    var isLoadingSubject: PassthroughSubject<Bool, Never> { get }
    var showWebViewSubject: PassthroughSubject<URL, Never> { get }
    var errorAlertSubject: PassthroughSubject<String, Never> { get }
    func fetch(query: String?) async
    func handleDidSelectRowAt(_ indexPath: IndexPath)
}

final class MainViewModel {
    var listSubject = CurrentValueSubject<[GithubRepo], Never>([])
    var isLoadingSubject = PassthroughSubject<Bool, Never>()
    var showWebViewSubject = PassthroughSubject<URL, Never>()
    var errorAlertSubject = PassthroughSubject<String, Never>()

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

    @MainActor private func showErrorAlert(_ message: String) {
        self.errorAlertSubject.send(message)
    }
}

// MARK: MainViewModelable
extension MainViewModel: MainViewModelable {
    func fetch(query: String?) async {
        do {
            guard let query = query else { return }
            await self.setupLoading(true)
            let list = try await apiClient.fetchGithubRepo(query: query).items
            await self.setupList(list)
            await self.setupLoading(false)
        } catch let error {
            await self.setupLoading(false)
            guard let error = error as? APIError else { return }
            await self.showErrorAlert(error.message)
        }
    }

    func handleDidSelectRowAt(_ indexPath: IndexPath) {
        let item = listSubject.value[indexPath.row]
        guard let url = URL(string: item.htmlUrl) else { return }
        showWebViewSubject.send(url)
    }
}
