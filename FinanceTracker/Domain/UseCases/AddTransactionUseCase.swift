//
//  AddTransactionUseCase.swift
//  FinanceTracker
//
//  Created by Doolot on 14/7/25.
//
import Foundation
import CoreData

final class AddTransactionUseCase: AddTransactionUseCaseProtocol {
    private let transactionService: TransactionDataServiceProtocol
    private let accountService: AccountDataServiceProtocol
    private let context: NSManagedObjectContext

    init(
        transactionService: TransactionDataServiceProtocol,
        accountService: AccountDataServiceProtocol,
        context: NSManagedObjectContext
    ) {
        self.transactionService = transactionService
        self.accountService = accountService
        self.context = context
    }

    func execute(transaction: Transaction, to account: Account) throws {
        // 1. Обновим баланс
        var updatedAccount = account
        switch transaction.type {
        case .income:
            updatedAccount.balance += transaction.amount
        case .expense:
            updatedAccount.balance -= transaction.amount
        }

        // 2. Привязка транзакции
        updatedAccount.transactions.append(transaction)

        // 3. Сохраняем через сервисы
        _ = accountService.upsert(updatedAccount, context: context)
        _ = transactionService.upsert(transaction, account: updatedAccount, context: context)

        try context.save()
    }
}
