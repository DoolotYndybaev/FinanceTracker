//
//  DashBoardViewModel.swift
//  FinanceTracker
//
//  Created by Doolot on 9/6/25.
//

import Foundation

final class DashboardViewModel: ObservableObject {
    // MARK: - Published
    @Published var accounts: [Account] = []
    @Published var transactions: [Transaction] = []
    @Published var isPresentingAddTransaction = false
    @Published var categories: [Category] = [
        Category(name: "Food", icon: "🍔", isIncome: false),
        Category(name: "Shopping", icon: "🛍", isIncome: false),
        Category(name: "Salary", icon: "💼", isIncome: true),
        Category(name: "Other", icon: "🔖", isIncome: false)
    ]

    // MARK: - Dependencies
    private let accountService: AccountDataServiceProtocol
    private let transactionService: TransactionDataServiceProtocol
    private let addTransactionUseCase: AddTransactionUseCaseProtocol

    // MARK: - Init
    init(
        accountService: AccountDataServiceProtocol,
        transactionService: TransactionDataServiceProtocol,
        addTransactionUseCase: AddTransactionUseCaseProtocol
    ) {
        self.accountService = accountService
        self.transactionService = transactionService
        self.addTransactionUseCase = addTransactionUseCase

        reloadData()
    }

    // MARK: - Computed
    var totalIncome: Double {
        transactionService.total(for: .income)
    }

    var totalExpense: Double {
        transactionService.total(for: .expense)
    }

    var totalBalance: Double {
        accounts.map(\.balance).reduce(0, +)
    }

    func accountName(index: Int) -> String {
        guard accounts.indices.contains(index) else {
            return "No Account"
        }
        return accounts[index].name
    }

    // MARK: - Actions
    func addTransaction(_ tn: Transaction, to account: Account) {
        do {
            try addTransactionUseCase.execute(transaction: tn, to: account)
            reloadData()
        } catch {
            print("❌ Failed to add transaction: \(error)")
        }
    }

    func reloadData() {
        accounts = accountService.fetchAllAccounts()
        transactions = transactionService.transactions
    }
}
