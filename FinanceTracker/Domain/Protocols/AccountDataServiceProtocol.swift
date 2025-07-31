//
//  AccountDataServiceProtocol.swift
//  FinanceTracker
//
//  Created by Doolot on 31/7/25.
//

import Combine
import CoreData

protocol AccountDataServiceProtocol {
    func fetchAllAccounts() -> [Account]
    func add(_ account: Account)
    func deleteAllAccounts()
    func delete(account: Account) throws
    func upsert(_ account: Account, context: NSManagedObjectContext) -> AccountEntity
}
