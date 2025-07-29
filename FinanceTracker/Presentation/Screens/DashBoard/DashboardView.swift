//
//  ContentView.swift
//  FinanceTracker
//
//  Created by Doolot on 9/6/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var session: UserSession
    @StateObject private var viewModel = DashboardViewModelFactory.make()
    @State private var isPresentingAddAccount = false

    private let addAccountUseCase: AddAccountUseCase

    init() {
        let context = CoreDataStack.shared.context

        let userService = CoreDataUserService(context: context)
        self.addAccountUseCase = AddAccountUseCase(userService: userService)
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack() {
                headerSection

                balanceCard
                    .padding()

                transactionsSection
            }
            
            Button(action: {
                viewModel.isPresentingAddTransaction = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .frame(width: 56, height: 56)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(radius: 8)
            }
            .padding([.bottom, .trailing], 24)
            .sheet(isPresented: $viewModel.isPresentingAddTransaction) {
                AddTransactionView(
                    accounts: $viewModel.accounts,
                    categories: $viewModel.categories,
                    onSave: { transaction, account in
                        viewModel.addTransaction(transaction, to: account)
                    }
                )
            }
            .sheet(isPresented: $isPresentingAddAccount) {
                AddAccountView { newAccount, transaction in
                    do {
                        try addAccountUseCase.execute(newAccount)
                        viewModel.addTransaction(transaction, to: newAccount)
                        session.restore() // обновим session.currentUser
                    } catch {
                        print("Ошибка при добавлении счёта: \(error)")
                    }
                    isPresentingAddAccount = false
                }
            }
            .onAppear {
                if (session.currentUser?.accounts ?? []).isEmpty {
                    isPresentingAddAccount = true
                }
            }
        }
    }

    private var headerSection: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("FinanceTracker")
                    .font(.title)
                    .bold()
            }
            Spacer()
            Image(systemName: "bell.badge.fill")
                .font(.title2)
        }
        .padding()

    }

    private var balanceCard: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Total Balance")
                    .font(.subheadline)
                Text("$\(viewModel.totalBalance, specifier: "%.2f")")
                    .font(.largeTitle)
                    .bold()
                HStack {
                    VStack(alignment: .leading) {
                        Text("Income")
                        Text("$\(viewModel.totalIncome, specifier: "%.2f")")
                            .foregroundColor(.green)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Expenses")
                        Text("$\(viewModel.totalExpense, specifier: "%.2f")")
                            .foregroundColor(.red)
                    }
                }
            }

            Text(viewModel.accountName(index: 0))
                .font(.subheadline)
                .padding(8)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(20)
    }

    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Transactions History")
                    .font(.headline)
                Spacer()
                Button("See all") { }
                    .font(.callout)
            }

            List {
                ForEach(viewModel.transactions.reversed()) { tx in
                    TransactionRowView(transaction: tx)
                }
            }
            .listStyle(PlainListStyle())
            .padding(.bottom, -20)
            .padding(.horizontal, -20)
        }
        .padding()
        .background(.clear)
    }
}

struct TransactionRowView: View {
    let transaction: Transaction

    var body: some View {
        HStack {
            Image(systemName: "arrow.up.right.circle.fill")
                .font(.title2)
                .foregroundColor(transaction.type == .income ? .green : .red)

            VStack(alignment: .leading) {
                Text(transaction.category.name)
                Text(transaction.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            Text("\(transaction.type == .income ? "+" : "-")$\(transaction.amount, specifier: "%.2f")")
                .bold()
                .foregroundColor(transaction.type == .income ? .green : .red)
        }
        .padding(.vertical, 4)
    }
}

struct AddAccountView: View {
    @Environment(\.dismiss) var dismiss
    @State private var name: String = ""
    @State private var balance: String = ""

    var onSave: (Account, Transaction) -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account Info")) {
                    TextField("Account Name", text: $name)
                    TextField("Initial Balance", text: $balance)
                        .keyboardType(.decimalPad)
                }
            }
            .navigationTitle("New Account")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard let amount = Double(balance) else { return }
                        let transaction = Transaction(
                            id: UUID(),
                            amount: amount,
                            date: Date(),
                            category: Category(name: "Initial Balance", icon: "💰", isIncome: true),
                            note: .empty,
                            type: .income
                        )
                        let account = Account(id: UUID(), name: name, balance: 0, transactions: []) // баланс обновится use-case'ом
                        onSave(account, transaction)
                        dismiss()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}
