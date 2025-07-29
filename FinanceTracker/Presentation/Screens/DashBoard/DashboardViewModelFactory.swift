//
//  DashboardViewModelFactory.swift
//  FinanceTracker
//
//  Created by Doolot on 28/7/25.
//

enum DashboardViewModelFactory {
    static func make() -> DashboardViewModel {
        let context = CoreDataStack.shared.context
        let accountService = CoreDataAccountService(context: context)
        let transactionService = CoreDataTransactionService(context: context)

        let addUseCase = AddTransactionUseCase(
            transactionService: transactionService,
            accountService: accountService,
            context: context
        )

        return DashboardViewModel(
            accountService: accountService,
            transactionService: transactionService,
            addTransactionUseCase: addUseCase
        )
    }
}
