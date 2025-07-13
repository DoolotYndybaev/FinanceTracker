//
//  DashBoardViewModel.swift
//  FinanceTracker
//
//  Created by Doolot on 9/6/25.
//

import Foundation

final class DashboardViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    private let transactionService: TransactionProtocol

    init(transactionService: TransactionProtocol = CoreDataTransactionService()) {
        self.transactionService = transactionService
        self.transactions = transactionService.transactions
    }

    var totalIncome: Double {
        transactionService.total(for: .income)
    }

    var totalExpense: Double {
        transactionService.total(for: .expense)
    }

    var totalBalance: Double {
        totalIncome - totalExpense
    }
}
