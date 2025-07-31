//
//  BalanceCardView.swift
//  FinanceTracker
//
//  Created by Doolot on 30/7/25.
//

import SwiftUI

struct BalanceCardView: View {
    let account: Account
    let totalIncome: Double
    let totalExpense: Double
    let isActive: Bool
    let onDelete: () -> Void

    @State private var isConfirmingDelete = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: 16) {
                Text(account.name)
                    .font(.subheadline)
                Text("$\(account.balance, specifier: "%.2f")")
                    .font(.largeTitle)
                    .bold()

                HStack {
                    VStack(alignment: .leading) {
                        Text("Income")
                        Text("$\(totalIncome, specifier: "%.2f")")
                            .foregroundColor(.green)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text("Expenses")
                        Text("$\(totalExpense, specifier: "%.2f")")
                            .foregroundColor(.red)
                    }
                }
            }

            // Кнопка удаления
            Button(action: {
                isConfirmingDelete = true
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.title3)
                    .foregroundColor(.red.opacity(0.8))
                    .padding(8)
            }
        }
        .confirmationDialog("Delete this account and all its transactions?", isPresented: $isConfirmingDelete, titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                onDelete()
            }
            Button("Cancel", role: .cancel) { }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 160)
        .background(Color(.systemGray6))
        .cornerRadius(20)
        .shadow(radius: 4)
        .scaleEffect(isActive ? 1.0 : 0.95)
        .opacity(isActive ? 1.0 : 0.3)
        .animation(.easeOut(duration: 0.9), value: isActive)
    }
}
