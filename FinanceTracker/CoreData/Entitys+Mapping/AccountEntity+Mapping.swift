//
//  AccountEntity+Mapping.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//

import CoreData

extension AccountEntity {
    func toModel() -> Account {
        Account(
            id: self.id ?? UUID(),
            name: self.name ?? "Unnamed Account",
            balance: self.balance,
            transactions: (self.transactions as? Set<TransactionEntity>)?.map { $0.toModel() } ?? []
        )
    }

    func update(from model: Account, context: NSManagedObjectContext) {
        self.id = model.id
        self.name = model.name
        self.balance = model.balance

        let transactionEntities = model.transactions.map { transaction in
            let entity = TransactionEntity(context: context)
            entity.update(from: transaction, context: context)
            return entity
        }

        self.transactions = NSSet(array: transactionEntities)
    }
}
