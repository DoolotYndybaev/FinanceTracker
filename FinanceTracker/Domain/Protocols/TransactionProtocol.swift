//
//  TransactionProtocol.swift
//  FinanceTracker
//
//  Created by Doolot on 19/6/25.
//

import Combine
import CoreData

protocol AddAccountUseCaseProtocol {
    func execute(_ account: Account) throws
}

protocol AddTransactionUseCaseProtocol {
    func execute(transaction: Transaction, to account: Account) throws
}

protocol AccountDataServiceProtocol {
    func fetchAllAccounts() -> [Account]
    func add(_ account: Account)
    func deleteAllAccounts()
    func upsert(_ account: Account, context: NSManagedObjectContext) -> AccountEntity
}

protocol TransactionDataServiceProtocol {
    var transactions: [Transaction] { get }
    func add(_ transaction: Transaction, to account: Account)
    func total(for type: TransactionType) -> Double
    func clearAll()
    func upsert(_ transaction: Transaction, account: Account, context: NSManagedObjectContext) -> TransactionEntity
}
