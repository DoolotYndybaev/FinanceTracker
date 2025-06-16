//
//  RootFlowView.swift
//  FinanceTracker
//
//  Created by Doolot on 10/6/25.
//

import SwiftUI

struct RootFlowView: View {
    @EnvironmentObject var router: AppRouter

    var body: some View {
        switch router.flow {
        case .splash:
            SplashView(onFinish: {
                router.resolveInitialFlow()
            })
        case .onboarding:
            OnboardingView(
                onFinish: { router.goToAuth() },
                onLoginTap: { router.goToAuth() },
                onGetStartedTap: { router.goToAuth() }
            )
        case .auth:
            AuthView {
//                UserDefaults.standard.set(true, forKey: "isAuthorized")
                router.goToAuth()
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
