//
//  AppRootView.swift
//  FinanceTracker
//
//  Created by Doolot on 10/6/25.
//

import SwiftUI

struct AppRootView: View {
    @EnvironmentObject var router: AppRouter         // Навигационный роутер приложения
    @EnvironmentObject var session: UserSession      // Состояние авторизации пользователя

    var body: some View {
        switch router.flow {
        case .splash:
            SplashView(onFinish: {
                router.resolveInitialFlow()
            })
        case .onboarding:
            OnboardingView(
                onLoginTap: { router.goToAuth(mode: .login) },
                onGetStartedTap: { router.goToAuth(mode: .register) }
            )
        case .auth(let mode):
            AuthView(viewModel: AuthViewModel(mode: mode, session: session)) {
                hideKeyboard()
                router.goToDashboard()
            }
        case .main(let mainFlow):
            switch mainFlow {
            case .tabBar:
                MainTabView()
            }
        }
    }
}

