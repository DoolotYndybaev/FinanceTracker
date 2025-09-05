//
//  ExchangeRateResponse.swift
//  FinanceTracker
//
//  Created by Doolot on 3/8/25.
//

import Foundation

struct ExchangeRateResponse: Decodable {
    let success: Bool?
    let base: String?
    let date: String?
    let rates: [String: Double]?
}
