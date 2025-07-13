//
//  MainTabView.swift
//  FinanceTracker
//
//  Created by Doolot on 13/7/25.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var router: AppRouter
    @State private var selected: TabFlow = .dashboard

    var body: some View {
        TabView(selection: $selected) {
            DashboardView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(TabFlow.dashboard)

            DashboardView()
                .tabItem {
                    Label("Exchange", systemImage: "dollarsign.circle")
                }
                .tag(TabFlow.exchange)

            DashboardView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle")
                }
                .tag(TabFlow.profile)
        }
        .onChange(of: selected) { newValue in
            router.flow = .main(.tabBar(newValue))
        }
        .onAppear {
            // Синхронизация при навигации через router
            if case .main(.tabBar(let tab)) = router.flow {
                selected = tab
            }
        }
    }
}
