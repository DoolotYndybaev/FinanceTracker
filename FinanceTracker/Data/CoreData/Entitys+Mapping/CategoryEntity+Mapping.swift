//
//  CategoryEntity+Mapping.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//

import CoreData

extension CategoryEntity {
    
    static func upsert(from model: Category, context: NSManagedObjectContext) -> CategoryEntity {
        let request: NSFetchRequest<CategoryEntity> = CategoryEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
        request.fetchLimit = 1
        
        let entity = (try? context.fetch(request).first) ?? CategoryEntity(context: context)

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
}
