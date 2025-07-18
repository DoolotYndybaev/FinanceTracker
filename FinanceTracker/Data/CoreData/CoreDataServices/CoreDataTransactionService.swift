//
//  CoreDataTransactionService.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//

import Foundation
import CoreData

final class CoreDataTransactionService: TransactionDataServiceProtocol {
    
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    var transactions: [Transaction] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        do {
            let entities = try context.fetch(request)
            return entities.compactMap { $0.toModel() }
        } catch {
            print("⚠️ Failed to fetch transactions:", error)
            return []
        }
    }

    func add(_ transaction: Transaction, to account: Account) {
        let accountEntity = AccountEntity.upsert(from: account, context: context)
        _ = TransactionEntity.upsert(from: transaction, account: accountEntity, context: context)
        CoreDataStack.shared.saveContext()
    }

    func total(for type: TransactionType) -> Double {
        transactions
            .filter { $0.type == type }
            .map { $0.amount }
            .reduce(0, +)
    }

    func clearAll() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = TransactionEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
            CoreDataStack.shared.saveContext()
        } catch {
            print("⚠️ Failed to delete all transactions:", error)
        }
    }

    func upsert(_ transaction: Transaction, account: Account, context: NSManagedObjectContext) -> TransactionEntity {
        let accountEntity = AccountEntity.upsert(from: account, context: context)
        return TransactionEntity.upsert(from: transaction, account: accountEntity, context: context)
    }
}
