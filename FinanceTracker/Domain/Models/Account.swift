//
//  Account.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//

import Foundation

struct Account: Identifiable, Codable {
    let id: UUID
    var name: String
    var balance: Double
    var transactions: [Transaction]
}
