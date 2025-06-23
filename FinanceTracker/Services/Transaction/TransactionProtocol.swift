//
//  TransactionProtocol.swift
//  FinanceTracker
//
//  Created by Doolot on 19/6/25.
//

import Combine

protocol TransactionProtocol {
    var transactions: [Transaction] { get }

    func add(_ transaction: Transaction)
    func total(for type: TransactionType) -> Double
    func clearAll()
}
