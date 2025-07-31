//
//  AddAccountView.swift
//  FinanceTracker
//
//  Created by Doolot on 29/7/25.
//

import SwiftUI

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
