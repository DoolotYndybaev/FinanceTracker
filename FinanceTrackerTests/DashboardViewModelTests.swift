//
//  DashboardViewModelTests.swift
//  FinanceTrackerTests
//
//  Created by ChatGPT Assistant
//

import XCTest
@testable import FinanceTracker
import CoreData

// MARK: - Mocks

final class MockAccountDataService: AccountDataServiceProtocol {
    private(set) var accounts: [Account] = []

    func fetchAllAccounts() -> [Account] {
        return accounts
    }

    func add(_ account: Account) {
        accounts.append(account)
    }

    func deleteAllAccounts() {
        accounts.removeAll()
    }

    func delete(account: Account) throws {
        accounts.removeAll { $0.id == account.id }
    }

    func upsert(_ account: Account, context: NSManagedObjectContext) -> AccountEntity {
        fatalError("Not needed for this test")
    }
}

final class MockTransactionDataService: TransactionDataServiceProtocol {
    private(set) var transactionList: [Transaction] = []

    var transactions: [Transaction] {
        return transactionList
    }

    func add(_ transaction: Transaction, to account: Account) {
        transactionList.append(transaction)
    }

    func total(for type: TransactionType) -> Double {
        transactions
            .filter { $0.type == type }
            .map { $0.amount }
            .reduce(0, +)
    }

    func clearAll() {
        transactionList.removeAll()
    }

    func upsert(_ transaction: Transaction, account: Account, context: NSManagedObjectContext) -> TransactionEntity {
        fatalError("Not needed for this test")
    }
}

final class MockUserService: UserDataServiceProtocol {
    private var user: User?

    func fetchUser() -> User? {
        return user
    }

    func saveUser(_ user: User) throws {
        self.user = user
    }

    func deleteUser() {
        user = nil
    }
}

// MARK: - UseCases

final class StubAddAccountUseCase: AddAccountUseCaseProtocol {
    private let userService: UserDataServiceProtocol
    private let accountService: AccountDataServiceProtocol

    init(userService: UserDataServiceProtocol, accountService: AccountDataServiceProtocol) {
        self.userService = userService
        self.accountService = accountService
    }

    func execute(_ account: Account) throws {
        guard var user = userService.fetchUser() else {
            throw AddAccountError.noUserFound
        }
        user.accounts.append(account)
        try userService.saveUser(user)

        accountService.add(account)
    }
}

final class StubAddTransactionUseCase: AddTransactionUseCaseProtocol {
    let transactionService: TransactionDataServiceProtocol
    let accountService: AccountDataServiceProtocol

    init(transactionService: TransactionDataServiceProtocol, accountService: AccountDataServiceProtocol) {
        self.transactionService = transactionService
        self.accountService = accountService
    }

    func execute(transaction: Transaction, to account: Account) throws {
        transactionService.add(transaction, to: account)

        // Обновляем аккаунт
        if let index = (accountService.fetchAllAccounts().firstIndex { $0.id == account.id }) {
            var updated = accountService.fetchAllAccounts()[index]
            updated.transactions.append(transaction)
            updated.balance += transaction.type == .income ? transaction.amount : -transaction.amount
            try? accountService.delete(account: updated)
            accountService.add(updated)
        }
    }
}

// MARK: - DashboardViewModelTests


final class DashboardViewModelTests: XCTestCase {

    func testAddAccountWithTransaction_shouldAddAccountAndTransaction() {
        // Arrange
        let mockAccountService = MockAccountDataService()
        let mockTransactionService = MockTransactionDataService()
        let mockUserService = MockUserService()
        
        // Предзаполненный пользователь
        let user = User(id: UUID(), name: "Test User",email: "Test email", password: "password", accounts: [])
        try? mockUserService.saveUser(user)

        let newAccount = Account(
            id: UUID(),
            name: "New Card",
            balance: 0,
            transactions: []
        )
        
        let initialTransaction = Transaction(
            id: UUID(),
            amount: 200,
            date: Date(),
            category: Category(name: "Deposit", icon: "🏦", isIncome: true),
            note: "Initial top-up",
            type: .income
        )

        let viewModel = DashboardViewModel(
            accountService: mockAccountService,
            transactionService: mockTransactionService,
            addAccountUseCase: StubAddAccountUseCase(userService: mockUserService, accountService: mockAccountService),
            addTransactionUseCase: StubAddTransactionUseCase(
                transactionService: mockTransactionService,
                accountService: mockAccountService
            )
        )

        // Act
        let expectation = XCTestExpectation(description: "Account and transaction added")
        viewModel.addAccount(newAccount, with: initialTransaction) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)

        // Assert
        XCTAssertEqual(viewModel.accounts.count, 1)
        XCTAssertEqual(viewModel.accounts.first?.name, "New Card")
        XCTAssertEqual(viewModel.accounts.first?.transactions.count, 1)
        XCTAssertEqual(viewModel.accounts.first?.balance, 200)
    }

    func testAddTransaction_shouldUpdateTotalIncomeAndAccountTransactions() {
        // Arrange
        let mockAccountService = MockAccountDataService()
        let mockTransactionService = MockTransactionDataService()
        let mockUserService = MockUserService()
        
        let account = Account(
            id: UUID(),
            name: "Cash",
            balance: 0,
            transactions: []
        )
        mockAccountService.add(account)
        
        let transaction = Transaction(
            id: UUID(),
            amount: 150,
            date: Date(),
            category: Category(name: "Salary", icon: "💼", isIncome: true),
            note: "Initial deposit",
            type: .income
        )
        
        let viewModel = DashboardViewModel(
            accountService: mockAccountService,
            transactionService: mockTransactionService,
            addAccountUseCase: StubAddAccountUseCase(userService: mockUserService, accountService: mockAccountService),
            addTransactionUseCase: StubAddTransactionUseCase(
                transactionService: mockTransactionService,
                accountService: mockAccountService))
        // Act
        viewModel.addTransaction(transaction, to: account)
        
        // Assert
        XCTAssertEqual(viewModel.transactions.count, 1)
        XCTAssertEqual(viewModel.totalIncome, 150)
        XCTAssertEqual(viewModel.totalExpense, 0)
    }

    func testAddExpenseTransaction_shouldUpdateTotalExpense() {
        let mockAccountService = MockAccountDataService()
        let mockTransactionService = MockTransactionDataService()
        let mockUserService = MockUserService()

        let account = Account(
            id: UUID(),
            name: "Cash",
            balance: 0,
            transactions: []
        )

        mockAccountService.add(account)

        let expenseTransaction = Transaction(
            id: UUID(),
            amount: 50,
            date: Date(),
            category: Category(name: "Food", icon: "🍔", isIncome: false),
            note: "Lunch",
            type: .expense
        )

        let viewModel = DashboardViewModel(
            accountService: mockAccountService,
            transactionService: mockTransactionService,
            addAccountUseCase: StubAddAccountUseCase(userService: mockUserService, accountService: mockAccountService),
            addTransactionUseCase: StubAddTransactionUseCase(
                transactionService: mockTransactionService,
                accountService: mockAccountService))
        // Act
        viewModel.addTransaction(expenseTransaction, to: account)
        
        // Assert
        XCTAssertEqual(viewModel.transactions.count, 1)
        XCTAssertEqual(viewModel.totalIncome, 0)
        XCTAssertEqual(viewModel.totalExpense, 50)
        XCTAssertEqual(viewModel.accounts.first?.balance, -50)
    }
}
