//
//  Account.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//

import Foundation

struct Account: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var balance: Double
    var transactions: [Transaction]
    
    init(id: UUID, name: String, balance: Double, transactions: [Transaction]) {
        self.id = id
        self.name = name
        self.balance = balance
        self.transactions = transactions
    }
}
