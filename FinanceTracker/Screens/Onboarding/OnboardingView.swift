//
//  OnboardingView.swift
//  FinanceTracker
//
//  Created by Doolot on 10/6/25.
//

import SwiftUI

struct OnboardingView: View {
    var onFinish: () -> Void
    var onLoginTap: () -> Void

    var body: some View {
        VStack {
            ZStack {
                Image("onboarding-background")
                    .frame(maxHeight: UIScreen.main.bounds.height * 0.45)
                    .scaledToFill()
                    .clipped()

                Image("onboarding-man")
            }


            VStack(spacing: 16) {
                Text("Spend Smarter\nSave More")
                    .multilineTextAlignment(.center)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(Color.mainColor)

                Button(action: {
                    onFinish()
                }) {
                    Text("Get Started")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("MainColor"))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                }

                HStack(spacing: 4) {
                    Text("Already Have Account?")
                        .foregroundColor(.secondary)
                        .font(.footnote)

                    Button(action: {
                        onLoginTap()
                    }) {
                        Text("Log In")
                            .foregroundColor(Color("MainColor"))
                            .font(.footnote)
                            .underline()
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
    }
}

#Preview {
    OnboardingView {
        print("")
    } onLoginTap: {
        print("")
    }
}
