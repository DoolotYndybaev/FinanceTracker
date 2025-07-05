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

    @Published var mode: Mode = .login
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String?
    
    init(mode: Mode = .login) {
        self.mode = mode
    }

    func handleAuth(success: @escaping () -> Void) {
        switch mode {
        case .login:
            guard !email.isEmpty, !password.isEmpty else { 
                errorMessage = "Email and password cannot be empty"
                return }

            success()

//            let storedEmail = UserDefaults.standard.string(forKey: "userEmail")
//            let storedPassword = UserDefaults.standard.string(forKey: "userPassword")
//            if email == storedEmail && password == storedPassword {
//                success()
//            } else {
//                errorMessage = "Incorrect credentials"
//            }
        case .register:
            guard password == confirmPassword else {
                errorMessage = "Passwords do not match"
                return
            }
//            UserDefaults.standard.set(email, forKey: "userEmail")
//            UserDefaults.standard.set(password, forKey: "userPassword")
            success()
        }
    }
}
