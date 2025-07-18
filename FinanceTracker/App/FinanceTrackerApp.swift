//
//  FinanceTrackerApp.swift
//  FinanceTracker
//
//  Created by Doolot on 9/6/25.
//

import SwiftUI

@main
struct FinanceTrackerApp: App {
    @StateObject private var session: UserSession
    @StateObject private var router: AppRouter

    init() {
        let session = UserSession()
        _session = StateObject(wrappedValue: session)
        _router = StateObject(wrappedValue: AppRouter(session: session))

        AppConfigurator.configure()
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(router)
                .environmentObject(session)
        }
    }
}
