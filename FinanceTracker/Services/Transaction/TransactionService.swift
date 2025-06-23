//
//  TransactionService.swift
//  FinanceTracker
//
//  Created by Doolot on 9/6/25.
//

import Foundation
import Combine

final class TransactionService: TransactionProtocol, ObservableObject {
    @Published private(set) var transactions: [Transaction] = []

    func add(_ transaction: Transaction) {
        transactions.append(transaction)
    }

    func total(for type: TransactionType) -> Double {
        transactions
            .filter { $0.type == type }
            .map { $0.amount }
            .reduce(0, +)
    }

    func clearAll() {
        transactions.removeAll()
    }
}
