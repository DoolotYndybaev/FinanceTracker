//
//  CoreDataTransactionService.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//

import Foundation
import CoreData

final class CoreDataTransactionService: TransactionProtocol {
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

    func add(_ transaction: Transaction) {
        _ = TransactionEntity.fromModel(transaction, context: context)
        
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
}
