//
//  MockAPIClient.swift
//  SampleTests
//
//  Created by fuwamaki on 2022/01/03.
//

import Foundation
@testable import Sample

class MockAPIClient: APIClientable {

    let mockGithubRepoList: GithubRepoList = GithubRepoList(
        items: [GithubRepo(
            fullName: "testName",
            stargazersCount: 10,
            htmlUrl: "https://www.google.com",
            owner: GithubRepoOwner(avatarUrl: "https://www.google.com")
        )]
    )

    private let isSuccess: Bool

    required init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }

    func fetchImageData(url: URL) async throws -> Data {
        if isSuccess {
            return Data()
        } else {
            throw APIError.unknownError
        }
    }

    func fetchGithubRepo(query: String) async throws -> GithubRepoList {
        if isSuccess {
            return mockGithubRepoList
        } else {
            throw APIError.unknownError
        }
    }
}
