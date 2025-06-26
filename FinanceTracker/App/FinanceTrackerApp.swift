//
//  FinanceTrackerApp.swift
//  FinanceTracker
//
//  Created by Doolot on 9/6/25.
//

import SwiftUI

@main
struct FinanceTrackerApp: App {
    @StateObject private var router = AppRouter()

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(router)
        }
    }
}
