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
                Task {
                    await viewModel.fetchRate()
                }
            }
            .onChange(of: viewModel.toCurrency) { _ in
                Task {
                    await viewModel.fetchRate()
                }
            }
        }
    }
}

