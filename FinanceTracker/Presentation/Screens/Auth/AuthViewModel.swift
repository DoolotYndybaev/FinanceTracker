//
//  AuthViewModel.swift
//  FinanceTracker
//
//  Created by Doolot on 14/6/25.
//

import Foundation
import SwiftUI

final class AuthViewModel: ObservableObject {
    enum Mode { case login, register }

    enum ErrorsFields: String {
        case fillInAllFields = "Fill in all fields"
        case emailAndPasswordNotMatch = "Email or password not match"
        case passwordsNotMatch = "Passwords not match"
        case errorSavingUser = "Error saving user"
    }

    @Published var mode: Mode = .login
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: ErrorsFields?

    private let userService = CoreDataUserService()
    private let session: UserSession
    
    init(mode: Mode = .login, session: UserSession) {
        self.mode = mode
        self.session = session
    }

    func handleAuth(success: @escaping () -> Void) {
        switch mode {
        case .login:
            guard !email.isEmpty, !password.isEmpty else { 
                errorMessage = .fillInAllFields
                return }

            if let user = userService.fetchUser(),
               user.email == email,
               user.password == password {
                session.logIn(user: user)
                success()
            } else {
                errorMessage = .emailAndPasswordNotMatch
                return
            }

        case .register:
            guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
                errorMessage = .fillInAllFields
                return
            }
            guard password == confirmPassword else {
                errorMessage = .passwordsNotMatch
                return
            }
            let newUser = User(
                id: UUID(),
                name: name,
                email: email,
                password: password,
                accounts: []
            )
            
            do {
                try userService.saveUser(newUser)
                session.logIn(user: newUser)
                success()
            } catch {
                errorMessage = .errorSavingUser
            }
        }
    }
}
