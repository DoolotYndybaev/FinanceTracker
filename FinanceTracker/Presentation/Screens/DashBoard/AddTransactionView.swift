//
//  AddTransactionView.swift
//  FinanceTracker
//
//  Created by Doolot on 14/7/25.
//

import SwiftUI

struct AddTransactionView: View {
    var accounts: [Account]
    var categories: [Category]
    var onSave: (Transaction, Account) -> Void

    @Environment(\.dismiss) private var dismiss

    @State private var selectedAccount: Account?
    @State private var selectedCategory: Category?
    @State private var amount: String = ""
    @State private var type: TransactionType = .expense
    @State private var note: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Account")) {
                    Picker("Account", selection: $selectedAccount) {
                        ForEach(accounts) { account in
                            Text(account.name).tag(Optional(account))
                        }
                    }
                }

                Section(header: Text("Category")) {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(filteredCategories) { category in
                            Text("\(category.icon) \(category.name)").tag(Optional(category))
                        }
                    }
                }

                Section(header: Text("Amount")) {
                    TextField("0.00", text: $amount)
                        .keyboardType(.decimalPad)
                }

                Section(header: Text("Note")) {
                    TextField("Enter note (optional)", text: $note)
                }

                Section(header: Text("Type")) {
                    Picker("Type", selection: $type) {
                        Text("Income").tag(TransactionType.income)
                        Text("Expense").tag(TransactionType.expense)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationTitle("Add Transaction")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveTransaction()
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

    private var filteredCategories: [Category] {
        categories.filter { $0.isIncome == (type == .income) }
    }

    private func saveTransaction() {
        guard
            let account = selectedAccount,
            let category = selectedCategory,
            let amountValue = Double(amount)
        else {
            return
        }

        let transaction = Transaction(
            amount: amountValue,
            date: Date(),
            category: category,
            note: note.isEmpty ? nil : note,
            type: type)

        onSave(transaction, account)
        dismiss()
    }
}
