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
    private let session = UserSession()

    init () {
        session.restore()
    }

    func goToOnboarding() {
        flow = .onboarding
    }

    func goToDashboard() {
        flow = .main(.dashboard)
    }
    
    func goToAuth(mode: AuthViewModel.Mode) {
        flow = .auth(mode)
    }

    // Дополнительно: логика автоопределения flow на старте
    func resolveInitialFlow() {
        flow = session.isLoggedIn ? .main(.dashboard) : .onboarding
    }
}
