//
//  APIClient.swift
//  Sample
//
//  Created by fuwamaki on 2022/01/03.
//

import Foundation
import Network

protocol APIClientable {
    func fetchImageData(url: URL) async throws -> Data
    func fetchGithubRepo(query: String) async throws -> GithubRepoList
}

final class APIClient: APIClientable {

    static var networkStatus: NWPath.Status = .satisfied

    func fetchImageData(url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
                  throw APIError.unknownError
              }
        return data
    }

    func fetchGithubRepo(query: String) async throws -> GithubRepoList {
        guard APIClient.networkStatus == .satisfied else {
            throw APIError.networkError
        }
        let url = APIUrl.githubRepo(query: query)
        debugPrint("Request: " + url.absoluteString)
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknownError
        }
        debugPrint("Response Status Code: " + String(httpResponse.statusCode))
        switch httpResponse.statusCode {
        case 200:
            return try JSONDecoder().decode(GithubRepoList.self, from: data)
        case 401:
            throw APIError.unauthorizedError
        case 503:
            throw APIError.maintenanceError
        default:
            throw APIError.unknownError
        }
    }
}
