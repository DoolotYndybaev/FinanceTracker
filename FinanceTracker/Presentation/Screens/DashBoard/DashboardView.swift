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

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack() {
                headerSection

                pagedBalanceCards

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
                    viewModel.addAccount(newAccount, with: transaction) {
                        session.restore()
                        isPresentingAddAccount = false
                    }
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

    private var pagedBalanceCards: some View {
        VStack(spacing: 0) {
            TabView(selection: $viewModel.selectedAccountIndex) {
                ForEach(Array(viewModel.accounts.enumerated()), id: \.element) { (index, account) in
                    BalanceCardView(
                        account: account,
                        totalIncome: viewModel.totalIncome,
                        totalExpense: viewModel.totalExpense,
                        isActive: viewModel.selectedAccountIndex == index,
                        onDelete: {
                            viewModel.delete(account: account)
                        }
                    )
                    .padding()
                    .tag(index)
                }

                addAccountCard
                    .tag(viewModel.accounts.count)
                    .padding()
            }
            .tabViewStyle(.page(indexDisplayMode: .never)) // скрываем системный индикатор
            .frame(height: 200)

            customPageIndicator // добавляем свой
        }
    }

    private var customPageIndicator: some View {
        HStack(spacing: 8) {
            ForEach(0..<(viewModel.accounts.count + 1), id: \.self) { index in
                Circle()
                    .fill(index == viewModel.selectedAccountIndex ? Color.blue : Color.gray.opacity(0.4))
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.top, 4)
    }

    private var transactionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Transactions History")
                    .font(.headline)
                Spacer()
                Picker("See all", selection: $viewModel.selectedFilter) {
                    ForEach(TransactionFilter.allCases) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.menu)
                .foregroundStyle(.main)
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

    private var addAccountCard: some View {
        Button(action: {
            isPresentingAddAccount = true
        }) {
            VStack(spacing: 12) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 42))
                    .foregroundColor(.blue)
                Text("Add Account")
                    .font(.headline)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 160)
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .shadow(radius: 4)
        }
    }
}
