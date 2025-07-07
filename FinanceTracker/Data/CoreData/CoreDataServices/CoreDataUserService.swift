//
//  CoreDataUserService.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//

import CoreData

final class CoreDataUserService {
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
        let request: NSFetchRequest<NSFetchRequestResult> = UserEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            _ = try context.execute(deleteRequest)
            CoreDataStack.shared.saveContext()
        } catch {
            print("⚠️ Failed to delete all accounts:", error)
        }
    }
}
