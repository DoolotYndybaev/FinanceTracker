//
//  TransactionProtocol.swift
//  FinanceTracker
//
//  Created by Doolot on 19/6/25.
//

import Combine

protocol TransactionProtocol {
    func add(_ transaction: Transaction, to account: Account)
    func total(for type: TransactionType) -> Double
    func clearAll()
    var transactions: [Transaction] { get }
}
