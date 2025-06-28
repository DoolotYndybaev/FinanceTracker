//
//  TransactionEntity+Mapping.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//

import Foundation
import CoreData

extension TransactionEntity {
    func toModel() -> Transaction {
        Transaction(
            id: self.id ?? UUID(),
            amount: self.amount,
            date: self.date ?? Date(),
            category: self.category?.toModel() ?? Category.default,
            note: self.note,
            type: TransactionType(rawValue: self.type ?? "expense") ?? .expense
        )
    }

    static func fromModel(_ model: Transaction, context: NSManagedObjectContext) -> TransactionEntity {
        let entity = TransactionEntity(context: context)
        entity.update(from: model, context: context)
        return entity
    }

    func update(from model: Transaction, context: NSManagedObjectContext) {
        self.id = model.id
        self.amount = model.amount
        self.date = model.date
        self.note = model.note
        self.type = model.type.rawValue

        // Привязываем категорию
        let categoryEntity = CategoryEntity(context: context)
        categoryEntity.update(from: model.category, context: context)
        self.category = categoryEntity
    }
}
