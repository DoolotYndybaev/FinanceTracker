//
//  TransactionEntity+Mapping.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//

import Foundation
import CoreData

extension TransactionEntity {
    static func upsert(from model: Transaction, account: AccountEntity, context: NSManagedObjectContext) -> TransactionEntity {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
        request.fetchLimit = 1

        let entity = (try? context.fetch(request).first) ?? TransactionEntity(context: context)
        entity.id = model.id
        entity.amount = model.amount
        entity.date = model.date
        entity.note = model.note
        entity.type = model.type == .income ? "income" : "expense"

        // Привязываем к аккаунту
        entity.account = account

        // 🧠 Upsert для Category
        let categoryEntity = CategoryEntity.upsert(from: model.category, context: context)
        entity.category = categoryEntity

        return entity
    }

    func toModel() -> Transaction {
        Transaction(
            id: self.id ?? UUID(),
            amount: self.amount,
            date: self.date ?? Date(),
            category: self.category?.toModel() ?? Category.default,
            note: self.note,
            type: self.type == "income" ? .income : .expense
        )
    }
}
