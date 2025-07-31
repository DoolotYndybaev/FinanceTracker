//
//  FinanceTrackerApp.swift
//  FinanceTracker
//
//  Created by Doolot on 9/6/25.
//

import SwiftUI

@main
struct FinanceTrackerApp: App {
    @StateObject private var session: UserSession           // Глобальное состояние авторизации пользователя
    @StateObject private var router: AppRouter              // Отвечает за навигацию между экранами

    init() {
        let session = UserSession()
        _session = StateObject(wrappedValue: session)
        _router = StateObject(wrappedValue: AppRouter(session: session))

        AppConfigurator.configure()                         // Глобальная конфигурация приложения
    }

    var body: some Scene {
        WindowGroup {
            AppRootView()
                .environmentObject(router)                  // Делаем AppRouter доступным во всем SwiftUI дереве
                .environmentObject(session)                 // Делаем UserSession доступным во всем SwiftUI дереве
        }
    }
}
