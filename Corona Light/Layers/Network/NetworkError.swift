//
//  NetworkError.swift
//  Corona Light
//
//  Created by iMamad on 12/11/20.
//

import Foundation


enum NetworkError {
    case serverDataError
    case requestError(String)
}
extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .serverDataError:
            let message = "serverDataError".localized()
            return message
        case .requestError(let message):
            return message
        }
    }
}
