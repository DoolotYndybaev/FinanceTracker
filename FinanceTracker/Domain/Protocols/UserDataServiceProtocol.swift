//
//  UserDataServiceProtocol.swift
//  FinanceTracker
//
//  Created by Doolot on 31/7/25.
//

protocol UserDataServiceProtocol {
    func fetchUser() -> User?
    func saveUser(_ user: User) throws
    func deleteUser()
}
