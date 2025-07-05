//
//  AccountEntity+Mapping.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//

import CoreData

extension AccountEntity {
    static func upsert(from model: Account, context: NSManagedObjectContext) -> AccountEntity {
        let request: NSFetchRequest<AccountEntity> = AccountEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
        request.fetchLimit = 1
        
        let entity = (try? context.fetch(request).first) ?? AccountEntity(context: context)
        entity.id = model.id
        entity.name = model.name
        entity.balance = model.balance

        // 🔁 Upsert для связанных транзакций
        let transactionEntities = model.transactions.map {
            TransactionEntity.upsert(from: $0, account: entity, context: context)
        }
        entity.transactions = NSSet(array: transactionEntities)

        return entity
    }
    
    func toModel() -> Account {
        Account(
            id: self.id ?? UUID(),
            name: self.name ?? "Unnamed Account",
            balance: self.balance,
            transactions: (self.transactions as? Set<TransactionEntity>)?.map { $0.toModel() } ?? []
        )
    }
}
