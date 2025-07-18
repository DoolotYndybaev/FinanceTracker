//
//  ContentView.swift
//  FinanceTracker
//
//  Created by Doolot on 9/6/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var session: UserSession
    @StateObject private var viewModel: DashboardViewModel
    @State private var isPresentingAddAccount = false

    private let addAccountUseCase: AddAccountUseCase

    init() {
        let context = CoreDataStack.shared.context

        let addTransactionUseCase = AddTransactionUseCase(
            transactionService: CoreDataTransactionService(context: context),
            accountService: CoreDataAccountService(context: context),
            context: context
        )

        let userService = CoreDataUserService(context: context)
        self.addAccountUseCase = AddAccountUseCase(userService: userService)

        _viewModel = StateObject(wrappedValue: DashboardViewModel(addTransactionUseCase: addTransactionUseCase))
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection
                    balanceCard
                    transactionsSection
                }
                .padding()
            }
            .background(Color.main)


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
                    accounts: session.currentUser?.accounts ?? [],
                    categories: viewModel.categories,
                    onSave: { transaction, account in
                        viewModel.addTransaction(transaction, to: account)
                    }
                )
            }
            .sheet(isPresented: $isPresentingAddAccount) {
                AddAccountView { newAccount in
                    do {
                        try addAccountUseCase.execute(newAccount)
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
                Text("Good afternoon,")
                    .font(.subheadline)
                    .foregroundColor(.white)
                Text(session.currentUser?.name ?? "Guest")
                    .font(.title)
                    .bold()
            }
            Spacer()
            Image(systemName: "bell.badge.fill")
                .font(.title2)
        }
    }

    private var balanceCard: some View {
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
            
            ForEach(viewModel.transactions.prefix(5)) { tx in
                TransactionRowView(transaction: tx)
            }
        }
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

    var onSave: (Account) -> Void

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
                        let account = Account(id: UUID(), name: name, balance: amount, transactions: [])
                        onSave(account)
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
