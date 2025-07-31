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
        let userService = CoreDataUserService(context: context)

        let addTransactionUseCase = AddTransactionUseCase(
            transactionService: transactionService,
            accountService: accountService,
            context: context
        )

        let addAccountUseCase = AddAccountUseCase(userService: userService)

        return DashboardViewModel(
            accountService: accountService,
            transactionService: transactionService,
            addAccountUseCase: addAccountUseCase,
            addTransactionUseCase: addTransactionUseCase)
    }
}
