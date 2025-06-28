//
//  CategoryEntity+Mapping.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//

import CoreData

extension CategoryEntity {
    
    static func fromModel(_ model: Category, context: NSManagedObjectContext) -> CategoryEntity {
         let entity = CategoryEntity(context: context)
         entity.id = model.id
         entity.name = model.name
         entity.icon = model.icon
         entity.isIncome = model.isIncome
         return entity
     }

    func toModel() -> Category {
        Category(
            id: self.id ?? UUID(),
            name: self.name ?? "Unknown",
            icon: self.icon ?? "💰",
            isIncome: self.isIncome
        )
    }

    func update(from model: Category, context: NSManagedObjectContext) {
        self.id = model.id
        self.name = model.name
        self.icon = model.icon
        self.isIncome = model.isIncome
    }
}
