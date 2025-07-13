//
//  ContentView.swift
//  FinanceTracker
//
//  Created by Doolot on 9/6/25.
//

import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var session: UserSession
    @StateObject private var viewModel = DashboardViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                balanceCard
                transactionsSection
            }
            .padding()
        }
        .background(Color.main)
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
                    .font(.footnote)
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
