//
//  User.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//

import Foundation

struct User: Identifiable, Codable {
    let id: UUID
    var name: String
    var email: String
    var password: String
    var accounts: [Account]
}
