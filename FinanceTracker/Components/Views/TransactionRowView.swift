//
//  TransactionRowView.swift
//  FinanceTracker
//
//  Created by Doolot on 29/7/25.
//

import SwiftUI

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
