//
//  DashBoardViewModel.swift
//  FinanceTracker
//
//  Created by Doolot on 9/6/25.
//

import Foundation
import Combine

final class DashboardViewModel: ObservableObject {
    private let service: TransactionProtocol
    private var cancellables = Set<AnyCancellable>()

    @Published var transactions: [Transaction] = []
    @Published var incomeTotal: Double = 0
    @Published var expenseTotal: Double = 0

    init(service: TransactionProtocol) {
        self.service = service
        load()
    }

    func load() {
        transactions = service.transactions
        incomeTotal = service.total(for: .income)
        expenseTotal = service.total(for: .expense)
    }

    func addTransaction(_ transaction: Transaction, to account: Account) {
        service.add(transaction, to: account)
    }
}
