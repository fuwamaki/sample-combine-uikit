//
//  MainViewModel.swift
//  Sample
//
//  Created by fuwamaki on 2022/01/03.
//

import Foundation

protocol MainViewModelable {}

final class MainViewModel {

    private let apiClient: APIClientable

    convenience init() {
        self.init(apiClient: APIClient())
    }

    init(apiClient: APIClientable) {
        self.apiClient = apiClient
    }
}

// MARK: MainViewModelable
extension MainViewModel: MainViewModelable {}
