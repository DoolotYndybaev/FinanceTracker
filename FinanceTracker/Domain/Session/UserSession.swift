//
//  UserSession.swift
//  FinanceTracker
//
//  Created by Doolot on 7/7/25.
//

import Foundation
import Combine

final class UserSession: ObservableObject {
    @Published var currentUser: User? = nil

    var isLoggedIn: Bool {
        currentUser != nil
    }

    func logIn(user: User) {
        currentUser = user
    }

    func logOut() {
        currentUser = nil
        CoreDataUserService().deleteUser()
    }

    func restore(using userService: CoreDataUserService = CoreDataUserService()) {
        let user = userService.fetchUser()
        DispatchQueue.main.async {
            self.currentUser = user
        }
    }
}
