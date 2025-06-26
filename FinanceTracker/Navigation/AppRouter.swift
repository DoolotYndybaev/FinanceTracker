//
//  AppRouter.swift
//  FinanceTracker
//
//  Created by Doolot on 10/6/25.
//

import Foundation
import Combine

final class AppRouter: ObservableObject {
    @Published var flow: AppFlow = .splash

    func goToOnboarding() {
        flow = .onboarding
    }

    func goToDashboard() {
        flow = .main(.dashboard)
    }
    
    func goToLogin() {
        flow = .login
    }

    func goToRegister() {
        flow = .letsStart
    }

    // Дополнительно: логика автоопределения flow на старте
    func resolveInitialFlow() {
        // Пример с UserDefaults
        if !UserDefaults.standard.bool(forKey: "isUserRegistered") {
            flow = .onboarding
        } else {
            flow = .main(.dashboard)
        }
    }
}
