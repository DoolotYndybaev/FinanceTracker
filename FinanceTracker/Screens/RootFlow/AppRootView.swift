//
//  AppRootView.swift
//  FinanceTracker
//
//  Created by Doolot on 10/6/25.
//

import SwiftUI

struct AppRootView: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
        switch router.flow {
        case .splash:
            SplashView(onFinish: {
                router.resolveInitialFlow()
            })
        case .onboarding:
            OnboardingView(
                onLoginTap: { router.goToLogin() },
                onGetStartedTap: { router.goToRegister() }
            )
        case .login:
            AuthView {
//                UserDefaults.standard.set(true, forKey: "isAuthorized")
                router.goToLogin()
            }
        case .letsStart:
            AuthView {
                router.goToRegister()
            }
        case .main(let mainFlow):
            MainFlowView(flow: mainFlow)
        }
    }
}

struct MainFlowView: View {
    let flow: MainFlow

    var body: some View {
        switch flow {
        case .dashboard:
            DashboardView()
        }
    }
}
