//
//  Untitled.swift
//  FinanceTracker
//
//  Created by Doolot on 28/7/25.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
    @Published var user: User?

    private let userService: UserDataServiceProtocol
    private let router: AppRouter

    init(userService: UserDataServiceProtocol, router: AppRouter) {
        self.userService = userService
        self.router = router
        fetchUser()
    }

    func fetchUser() {
        user = userService.fetchUser()
    }

    func logout() {
        userService.deleteUser()
        router.flow = .onboarding
    }
}
