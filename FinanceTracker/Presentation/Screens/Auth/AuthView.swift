//
//  AuthView.swift
//  FinanceTracker
//
//  Created by Doolot on 14/6/25.
//

import SwiftUI

struct AuthView: View {
    var onFinish: () -> Void

    @StateObject private var viewModel: AuthViewModel
    @State private var isShowingAlert = false
    @State private var alertMessage: String = ""

    init(viewModel: AuthViewModel, onFinish: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onFinish = onFinish
    }

    var body: some View {
        Text(viewModel.mode == .login ? "Welcome Back" : "Create Account")
            .font(.title.bold())
            .padding(.top)
            .foregroundStyle(.main)

        VStack(spacing: 24) {
            Image(viewModel.mode == .login ? Image.AuthImages.welcomeMan : Image.AuthImages.smileMan)

                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)

            TextField("Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)

            if viewModel.mode == .register {
                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
            }

            PrimaryButton(
                title: viewModel.mode == .login ? "Log In" : "Register",
                action: {
                    viewModel.handleAuth {
                        onFinish()
                    }
                }
            )

            Button {
                withAnimation {
                    viewModel.mode = viewModel.mode == .login ? .register : .login
                    viewModel.errorMessage = nil
                }
            } label: {
                Text(viewModel.mode == .login ? "Don't have an account? Register"
                                              : "Already have an account? Log In")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
        }
        .padding(.horizontal, 24)
        .onReceive(viewModel.$errorMessage.compactMap { $0 }) { message in
            alertMessage = message.rawValue
            isShowingAlert = true
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK")) {
                    viewModel.errorMessage = nil
                }
            )
        }
    }
}

#Preview {
    AuthView(viewModel: AuthViewModel(mode: .register)) {
        print("AuthView finished")
    }
}
