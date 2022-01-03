//
//  APIError.swift
//  Sample
//
//  Created by fuwamaki on 2022/01/03.
//

import Foundation

enum APIError: Error {
    case customError(message: String)
    case unauthorizedError
    case maintenanceError
    case networkError
    case jsonParseError
    case unknownError

    var message: String {
        switch self {
        case .customError(let message):
            return message
        case .unauthorizedError:
            return "ユーザーセッションの有効期限が切れたため、再度ログインしてください。"
        case .maintenanceError:
            return "メンテナンス中です。終了までしばらくお待ちください。"
        case .networkError:
            return "通信エラーが発生しました。電波の良い所で再度お試しください。"
        case .jsonParseError:
            return "申し訳ありません、データが見つかりませんでした。"
        default:
            return "不具合が発生しました。お手数ですが時間をおいてもう一度お試しください。"
        }
    }
}
