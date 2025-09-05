//
//  ExchangeView.swift
//  FinanceTracker
//
//  Created by Doolot on 3/8/25.
//

import SwiftUI

enum Currencies: String, CaseIterable, Identifiable {
    case RUB = "RUB"
    case USD = "USD"
    case KGS = "KGS"
    case EUR = "EUR"

    var id: String { rawValue }
}

struct ExchangeView: View {
    @StateObject var viewModel = ExchangeViewModel(exchangeService: ExchangeRateServiceAdapter())


    var body: some View {
        ZStack {
            // Прозрачный фон, перехватывающий тапы и скрывающий клавиатуру
            Color.clear
                .contentShape(Rectangle()) // делает область кликабельной
                .onTapGesture {
                    hideKeyboard()
                }

            mainContent
        }
    }

    var mainContent: some View {
        VStack {
            VStack(alignment: .center) {
                Text("Currency exchange")
                    .font(.title)
                    .bold()
            }

            VStack(spacing: 24) {
                Spacer()
                
                Picker("Top Picker", selection: $viewModel.fromCurrency) {
                    ForEach(Currencies.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)

                VStack(alignment: .leading, spacing: 8) {
                    Text("У меня есть")
                        .font(.title2)
                        .foregroundColor(.gray)

                    TextField("0", text: $viewModel.inputAmount)
                        .keyboardType(.decimalPad)
                        .font(.system(size: 36, weight: .bold))
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                }

                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.swapCurrencies()
                    }) {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.title2)
                            .padding()
                            .background(Circle().fill(Color(.systemGray5)))
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Я получу")
                        .font(.title2)
                        .foregroundColor(.gray)

                    Text(viewModel.convertedText)
                        .font(.system(size: 36, weight: .bold))
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(12)
                }

                Picker("Bottom Picker", selection: $viewModel.toCurrency) {
                    ForEach(Currencies.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)

                Spacer()
            }
            .padding()
            .onChange(of: viewModel.inputAmount) { _ in
                viewModel.calculateExchange()
            }
            .onChange(of: viewModel.fromCurrency) { _ in
                viewModel.fetchRate()
            }
            .onChange(of: viewModel.toCurrency) { _ in
                viewModel.fetchRate()
            }
        }
    }
}

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
        fetchRate()
    }

    func fetchRate() {
        Task {
            let rate = await exchangeService.getRate(from: fromCurrency.rawValue, to: toCurrency.rawValue)
            await MainActor.run {
                self.exchangeRate = rate
            }
        }
    }

    func calculateExchange() {
        guard let amount = Double(inputAmount),
              let rate = exchangeRate else { return }
        convertedAmount = amount * rate
    }

    var convertedText: String {
        guard let result = convertedAmount else { return "—" }
        return String(format: "%.2f %@", result, toCurrency.rawValue)
    }

    func swapCurrencies() {
        (fromCurrency, toCurrency) = (toCurrency, fromCurrency)
        fetchRate()
        calculateExchange()
    }
}

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
