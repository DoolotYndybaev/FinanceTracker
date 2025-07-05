//
//  UserEntity+Mapping.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//

import CoreData

extension UserEntity {
    func toModel() -> User {
        User(
            id: self.id ?? UUID(),
            name: self.name ?? "No Name",
            email: self.email ?? "no@email.com",
            accounts: (self.accounts as? Set<AccountEntity>)?.map { $0.toModel() } ?? []
        )
    }

    static func upsert(from model: User, context: NSManagedObjectContext) -> UserEntity {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", model.id as CVarArg)
        request.fetchLimit = 1

        let entity = (try? context.fetch(request).first) ?? UserEntity(context: context)
        entity.id = model.id
        entity.name = model.name
        entity.email = model.email

        // 🔁 Upsert accounts
        let accountEntities = model.accounts.map { account in
            let accEntity = AccountEntity.upsert(from: account, context: context)
            accEntity.user = entity
            return accEntity
        }

        entity.accounts = NSSet(array: accountEntities)

        return entity
    }
}
