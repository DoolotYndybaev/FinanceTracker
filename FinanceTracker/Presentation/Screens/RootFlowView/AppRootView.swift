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
                onLoginTap: { router.goToAuth(mode: .login) },
                onGetStartedTap: { router.goToAuth(mode: .register) }
            )
        case .auth(let mode):
            let viewModel = AuthViewModel(mode: mode)
            AuthView(viewModel: viewModel) {
                hideKeyboard()
                router.goToDashboard()
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
