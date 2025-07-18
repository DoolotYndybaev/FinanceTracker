//
//  DashBoardViewModel.swift
//  FinanceTracker
//
//  Created by Doolot on 9/6/25.
//

import Foundation

final class DashboardViewModel: ObservableObject {
    @Published var accounts: [Account] = []
    @Published var transactions: [Transaction] = []
    @Published var isPresentingAddTransaction = false
    @Published var categories: [Category] = [
        Category(name: "Food", icon: "🍔", isIncome: false),
        Category(name: "Shopping", icon: "🛍", isIncome: false),
        Category(name: "Salary", icon: "💼", isIncome: true),
        Category(name: "Other", icon: "🔖", isIncome: false)
    ]

    private let accountService: AccountDataServiceProtocol
    private let transactionService: TransactionDataServiceProtocol
    private let addTransactionUseCase: AddTransactionUseCaseProtocol

    init(
        accountService: AccountDataServiceProtocol = CoreDataAccountService(),
        transactionService: TransactionDataServiceProtocol = CoreDataTransactionService(),
        addTransactionUseCase: AddTransactionUseCaseProtocol
    ) {
        self.transactionService = transactionService
        self.addTransactionUseCase = addTransactionUseCase
        self.accountService = accountService
        reloadData()
    }

    var totalIncome: Double {
        transactionService.total(for: .income)
    }

    var totalExpense: Double {
        transactionService.total(for: .expense)
    }

    var totalBalance: Double {
        accountService.fetchAllAccounts().first?.balance ?? 0
    }

    func addTransaction(_ tn: Transaction, to account: Account) {
        do {
            try addTransactionUseCase.execute(transaction: tn, to: account)
            reloadData()
        } catch {
            print("❌ Failed to add transaction: \(error)")
        }
    }

    private func reloadData() {
        transactions = transactionService.transactions
    }
}
