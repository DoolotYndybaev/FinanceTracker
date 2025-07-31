//
//  TransactionProtocol.swift
//  FinanceTracker
//
//  Created by Doolot on 19/6/25.
//

import Combine
import CoreData

protocol AddAccountUseCaseProtocol {
    func execute(_ account: Account) throws
}

protocol AddTransactionUseCaseProtocol {
    func execute(transaction: Transaction, to account: Account) throws
}


