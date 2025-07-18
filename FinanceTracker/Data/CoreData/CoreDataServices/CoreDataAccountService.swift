//
//  Untitled.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//
import CoreData

final class CoreDataAccountService: AccountDataServiceProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext = CoreDataStack.shared.context) {
        self.context = context
    }

    func fetchAllAccounts() -> [Account] {
        let request: NSFetchRequest<AccountEntity> = AccountEntity.fetchRequest()
        return (try? context.fetch(request).compactMap { $0.toModel() }) ?? []
    }

    func add(_ account: Account) {
        _ = AccountEntity.upsert(from: account, context: context)
        CoreDataStack.shared.saveContext()
    }

    func deleteAllAccounts() {
        let request: NSFetchRequest<NSFetchRequestResult> = AccountEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)

        do {
            _ = try context.execute(deleteRequest)
            CoreDataStack.shared.saveContext()
        } catch {
            print("⚠️ Failed to delete all accounts:", error)
        }
    }

    func upsert(_ account: Account, context: NSManagedObjectContext) -> AccountEntity {
        return AccountEntity.upsert(from: account, context: context)
    }
}
