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
    private var session = UserSession()

    init(session: UserSession) {
        self.session = session
        session.restore()
    }

    func goToOnboarding() {
        flow = .onboarding
    }

    func goToDashboard() {
        flow = .main(.tabBar(.dashboard))
    }

    func goToExchange() {
        flow = .main(.tabBar(.exchange))
    }

    func goToProfile() {
        flow = .main(.tabBar(.profile))
    }
    
    func goToAuth(mode: AuthViewModel.Mode) {
        flow = .auth(mode)
    }

    // Дополнительно: логика автоопределения flow на старте
    func resolveInitialFlow() {
        flow = session.isLoggedIn ? .main(.tabBar(.dashboard)) : .onboarding
    }
}
