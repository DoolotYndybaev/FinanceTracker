//
//  NetworkError.swift
//  FinanceTracker
//
//  Created by Doolot on 3/8/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
    case unexpectedStatusCode(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Недопустимый URL"
        case .requestFailed(let error):
            return "Ошибка запроса: \(error.localizedDescription)"
        case .invalidResponse:
            return "Некорректный ответ от сервера"
        case .decodingFailed(let error):
            return "Ошибка декодирования: \(error.localizedDescription)"
        case .unexpectedStatusCode(let code):
            return "Неожиданный код ответа: \(code)"
        }
    }
}
