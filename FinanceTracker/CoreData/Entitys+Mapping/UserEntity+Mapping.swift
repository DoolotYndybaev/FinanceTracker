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

    func update(from model: User, context: NSManagedObjectContext) {
        self.id = model.id
        self.name = model.name
        self.email = model.email

        let accountEntities = model.accounts.map { account in
            let entity = AccountEntity(context: context)
            entity.update(from: account, context: context)
            return entity
        }

        self.accounts = NSSet(array: accountEntities)
    }
}
