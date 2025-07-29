//
//  CoreDataUserService.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//

import CoreData

protocol UserDataServiceProtocol {
    func fetchUser() -> User?
    func saveUser(_ user: User) throws
    func deleteUser()
}

final class CoreDataUserService: UserDataServiceProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func fetchUser() -> User? {
        let request: NSFetchRequest<UserEntity> = UserEntity.fetchRequest()
        request.fetchLimit = 1
        return try? context.fetch(request).first?.toModel()
    }

    func saveUser(_ model: User) throws {
        let _ = UserEntity.upsert(from: model, context: context)
        CoreDataStack.shared.saveContext()
    }

    func deleteUser() {
        deleteAllEntities(named: "UserEntity")
        deleteAllEntities(named: "AccountEntity")
        deleteAllEntities(named: "TransactionEntity")
        deleteAllEntities(named: "CategoryEntity")
        CoreDataStack.shared.saveContext()
    }

    private func deleteAllEntities(named entityName: String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("⚠️ Failed to delete \(entityName):", error)
        }
    }
}
