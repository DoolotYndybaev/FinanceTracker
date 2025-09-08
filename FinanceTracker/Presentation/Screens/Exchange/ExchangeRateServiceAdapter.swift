//
//  ExchangeRateServiceAdapter.swift
//  FinanceTracker
//
//  Created by Doolot on 8/9/25.
//

final class ExchangeRateServiceAdapter: ExchangeRateServiceProtocol {
    private let currencyService: CurrencyService
    private var cachedRates: [String: [String: Double]] = [:]

    // Список нужных валют
    private let supportedCurrencies = ["USD", "EUR", "KGS", "RUB", "GBP"]

    init(currencyService: CurrencyService = CurrencyService()) {
        self.currencyService = currencyService
    }

    func getRate(from: String, to: String) async -> Double? {
        if let cached = cachedRates[from], let rate = cached[to] {
            return rate
        }

        do {
            let allRates = try await currencyService.getExchangeRates(base: from)
            let filteredRates = allRates.filter { supportedCurrencies.contains($0.key) }
            cachedRates[from] = filteredRates
            return filteredRates[to]
        } catch {
            print("❌ Ошибка получения курсов: \(error)")
            return nil
        }
    }
}
