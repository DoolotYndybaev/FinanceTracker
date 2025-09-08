//
//  ExchangeViewModel.swift
//  FinanceTracker
//
//  Created by Doolot on 8/9/25.
//

import Foundation
import SwiftUI

protocol ExchangeRateServiceProtocol {
    /// Получить курс валюты `from` к валюте `to`
    func getRate(from: String, to: String) async -> Double?
}

final class ExchangeViewModel: ObservableObject {
    @Published var inputAmount: String = ""
    @Published var fromCurrency: Currencies = .USD
    @Published var toCurrency: Currencies = .KGS
    @Published var exchangeRate: Double?
    @Published var convertedAmount: Double?

    private let exchangeService: ExchangeRateServiceProtocol

    init(exchangeService: ExchangeRateServiceProtocol) {
        self.exchangeService = exchangeService
        Task {
            await fetchRate()
        }
    }

    /// Асинхронное получение курса валют с обновлением UI на главном потоке
    func fetchRate() async {
        let rate = await exchangeService.getRate(from: fromCurrency.rawValue, to: toCurrency.rawValue)
        await MainActor.run {
            self.exchangeRate = rate
        }
    }

    @MainActor
    func calculateExchange() {
        guard let rate = exchangeRate else { return }
        let amount = Double(inputAmount) ?? 0
        convertedAmount = amount * rate
        convertedAmount = (amount * rate).rounded(toPlaces: 2)
    }

    var convertedText: String {
        let result = convertedAmount ?? 0.0
        return String(format: "%.2f %@", result, toCurrency.rawValue)
    }

    func swapCurrencies() {
        Task {
            let previousConverted = String(convertedAmount ?? .zero)
            
            await MainActor.run {
                (fromCurrency, toCurrency, inputAmount) = (toCurrency, fromCurrency, previousConverted)
            }

            await fetchRate() // дождаться получения актуального курса

            await MainActor.run {
                calculateExchange()
            }
        }
    }
}

