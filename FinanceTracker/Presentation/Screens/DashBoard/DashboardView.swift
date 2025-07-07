//
//  ContentView.swift
//  FinanceTracker
//
//  Created by Doolot on 9/6/25.
//

import SwiftUI

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel(service: CoreDataTransactionService())

    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                Text("Balance")
                    .font(.headline)
                HStack {
                    Text("Income: +\(viewModel.incomeTotal, specifier: "%.2f")")
                        .foregroundColor(.green)
                    Spacer()
                    Text("Expense: -\(viewModel.expenseTotal, specifier: "%.2f")")
                        .foregroundColor(.red)
                }

                List(viewModel.transactions) { transaction in
                    VStack(alignment: .leading) {
                        Text(transaction.category.name)
                            .font(.headline)
                        Text(transaction.note ?? "")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text("\(transaction.amount, specifier: "%.2f")")
                            .foregroundColor(transaction.type == .income ? .green : .red)
                    }
                }
                Button("Logout") {
                    UserSession().logOut()
                }
            }
            .padding()
            .navigationTitle("Dashboard")
        }
    }
}
#Preview {
    DashboardView()
}
