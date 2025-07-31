//
//  DashBoardViewModel.swift
//  FinanceTracker
//
//  Created by Doolot on 9/6/25.
//

import Foundation
import SwiftUICore

enum TransactionFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case income = "Income"
    case expense = "Expense"

    var id: String { rawValue }
}

final class DashboardViewModel: ObservableObject {
    // MARK: - Published
    @Published var accounts: [Account] = []
    @Published var isPresentingAddTransaction = false
    @Published var categories: [Category] = [
        Category(name: "Food", icon: "🍔", isIncome: false),
        Category(name: "Shopping", icon: "🛍", isIncome: false),
        Category(name: "Salary", icon: "💼", isIncome: true),
        Category(name: "Other", icon: "🔖", isIncome: false)
    ]
    @Published var selectedAccountIndex: Int = 0
    @Published var selectedFilter: TransactionFilter = .all

     var selectedAccount: Account? {
         guard accounts.indices.contains(selectedAccountIndex) else { return nil }
         return accounts[selectedAccountIndex]
     }

    // MARK: - Dependencies
    private let accountService: AccountDataServiceProtocol
    private let transactionService: TransactionDataServiceProtocol
    private let addAccountUseCase: AddAccountUseCaseProtocol
    private let addTransactionUseCase: AddTransactionUseCaseProtocol

    // MARK: - Init
    init(
        accountService: AccountDataServiceProtocol,
        transactionService: TransactionDataServiceProtocol,
        addAccountUseCase: AddAccountUseCaseProtocol,
        addTransactionUseCase: AddTransactionUseCaseProtocol) {
        self.accountService = accountService
        self.transactionService = transactionService
        self.addAccountUseCase = addAccountUseCase
        self.addTransactionUseCase = addTransactionUseCase
        reloadData()
    }

    // MARK: - Computed
    var totalIncome: Double {
        guard let account = selectedAccount else { return 0 }
        return account.transactions
            .filter { $0.type == .income }
            .map { $0.amount }
            .reduce(0, +)
    }

    var totalExpense: Double {
        guard let account = selectedAccount else { return 0 }
        return account.transactions
            .filter { $0.type == .expense }
            .map { $0.amount }
            .reduce(0, +)
    }

    var transactions: [Transaction] {
        guard let account = selectedAccount else { return [] }

        switch selectedFilter {
        case .all:
            return account.transactions
        case .income:
            return account.transactions.filter { $0.type == .income }
        case .expense:
            return account.transactions.filter { $0.type == .expense }
        }
    }

    var totalBalance: Double {
        accounts.map(\.balance).reduce(0, +)
    }

    // MARK: - Actions

    func addAccount(_ account: Account, with transaction: Transaction, onFinish: @escaping () -> Void) {
        do {
            try addAccountUseCase.execute(account)
            try addTransactionUseCase.execute(transaction: transaction, to: account)
            reloadData()
            onFinish()
        } catch {
            print("❌ Failed to add account or transaction: \(error)")
        }
    }

    func addTransaction(_ tn: Transaction, to account: Account) {
        do {
            try addTransactionUseCase.execute(transaction: tn, to: account)
            reloadData()
        } catch {
            print("❌ Failed to add transaction: \(error)")
        }
    }

    func delete(account: Account) {
        do {
            try accountService.delete(account: account)
            reloadData()

            // Если после удаления индекс выходит за пределы — корректируем его
            if selectedAccountIndex >= accounts.count {
                selectedAccountIndex = max(0, accounts.count - 1)
            }
        } catch {
            print("❌ Failed to delete account: \(error)")
        }
    }

    func reloadData() {
        accounts = accountService.fetchAllAccounts()
    }
}
