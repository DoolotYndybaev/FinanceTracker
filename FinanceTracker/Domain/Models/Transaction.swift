//
//  Transaction.swift
//  FinanceTracker
//
//  Created by Doolot on 9/6/25.
//

import Foundation

enum TransactionType: String, Codable {
    case income
    case expense
}

struct Transaction: Identifiable, Codable {
    let id: UUID
    let amount: Double
    let date: Date
    let category: Category
    let note: String?
    let type: TransactionType

    init(
        amount: Double,
        date: Date = Date(),
        category: Category,
        note: String? = nil,
        type: TransactionType
    ) {
        self.id = UUID()
        self.amount = amount
        self.date = date
        self.category = category
        self.note = note
        self.type = type
    }
}

extension Transaction {
    init(
        id: UUID,
        amount: Double,
        date: Date,
        category: Category,
        note: String?,
        type: TransactionType
    ) {
        self.id = id
        self.amount = amount
        self.date = date
        self.category = category
        self.note = note
        self.type = type
    }
}
