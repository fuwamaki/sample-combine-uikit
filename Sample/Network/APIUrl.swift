//
//  APIUrl.swift
//  Sample
//
//  Created by fuwamaki on 2022/01/03.
//

import Foundation

struct APIUrl {
    static func githubRepo(query: String) -> URL {
        return URL(string: "https://api.github.com/search/repositories?q=\(query)")!
    }
}
