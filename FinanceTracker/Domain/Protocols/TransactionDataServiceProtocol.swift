//
//  TransactionDataServiceProtocol.swift
//  FinanceTracker
//
//  Created by Doolot on 31/7/25.
//

import Combine
import CoreData

protocol TransactionDataServiceProtocol {
    var transactions: [Transaction] { get }
    func add(_ transaction: Transaction, to account: Account)
    func total(for type: TransactionType) -> Double
    func clearAll()
    func upsert(_ transaction: Transaction, account: Account, context: NSManagedObjectContext) -> TransactionEntity
}
