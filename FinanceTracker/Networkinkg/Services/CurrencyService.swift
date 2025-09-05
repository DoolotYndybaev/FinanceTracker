//
//  CurrencyService.swift
//  FinanceTracker
//
//  Created by Doolot on 3/8/25.
//

import Foundation

final class CurrencyService {
    private let apiClient = APIClient()

    func getExchangeRates(base: String) async throws -> [String: Double] {
           let endpoint = ExchangeRateEndpoint(baseCurrency: base)
           let response = try await apiClient.send(endpoint, responseType: ExchangeRateResponse.self)

           guard response.success != false else {
               throw NetworkError.invalidResponse
           }

           guard let rates = response.rates else {
               throw NetworkError.decodingFailed(DecodingError.dataCorrupted(.init(codingPath: [], debugDescription: "Rates отсутствует")))
           }

           return rates
       }

    func convert(amount: Double, from: String, to: String, rates: [String: Double]) -> Double? {
        guard let rate = rates[to] else { return nil }
        return amount * rate
    }
}
