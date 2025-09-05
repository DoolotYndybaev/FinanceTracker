//
//  ExchangeRateEndpoint.swift
//  FinanceTracker
//
//  Created by Doolot on 3/8/25.
//

import Foundation

struct ExchangeRateEndpoint: Endpoint {
    var baseURL: URL { URL(string: "https://open.er-api.com")! }
    var path: String { "v6/latest/\(baseCurrency)" }
    var method: String { "GET" }
    var headers: [String: String]? { nil }
    var queryItems: [URLQueryItem]? { nil }
    var body: Data? { nil }

    let baseCurrency: String
}
