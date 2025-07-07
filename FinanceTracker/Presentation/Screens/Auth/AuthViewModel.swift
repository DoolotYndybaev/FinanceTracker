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
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: ErrorsFields?

    private let userService = CoreDataUserService()
    
    init(mode: Mode = .login) {
        self.mode = mode
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
                print("User logged in successfully!")
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
            do {
                try userService.saveUser(.init(id: UUID(),
                                           name: "",
                                           email: email,
                                           password: password,
                                           accounts: []))
                success()
                print("User saved successfully!")
            }
            catch {
                errorMessage = .errorSavingUser
                print("Error saving user")
            }
        }
    }
}
