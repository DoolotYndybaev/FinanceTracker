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
            OnboardingView(onFinish: {
                UserDefaults.standard.set(true, forKey: "isUserRegistered")
                router.goToPin()
            })
        case .pin:
            SplashView(onFinish: {
                router.resolveInitialFlow()
            })
        case .dashboard:
            DashboardView()
        }
    }
}
