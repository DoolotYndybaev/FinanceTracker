//
//  AppFlow.swift
//  FinanceTracker
//
//  Created by Doolot on 10/6/25.
//

enum AppFlow {
    case splash
    case onboarding
    case login
    case letsStart
    case main(MainFlow)
}

enum MainFlow {
    case dashboard
//    case transactions
//    case settings
}
