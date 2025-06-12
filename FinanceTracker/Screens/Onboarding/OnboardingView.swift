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
        GeometryReader { geometry in
            VStack(spacing: 30) {
                ZStack {
                    Image.OnboardingImage.backgroundImage
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .ignoresSafeArea(edges: .top)
                        .frame(height: geometry.size.height * 0.556)
                        .shadow(color: .black,
                                radius: 5,
                                x: 0,
                                y: 5)

                    Image.OnboardingImage.onboardingMan
                        .resizable()
                        .scaledToFit()
                        .frame(height: geometry.size.height * 0.55)
                        .shadow(color: .black,
                                radius: 15,
                                x: 0,
                                y: 20)

                    Image.OnboardingImage.donut
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .offset(x: 140, y: -geometry.size.height * 0.18)

                    Image.OnboardingImage.coint
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .offset(x: -120, y: -geometry.size.height * 0.25)
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
                            .foregroundColor(.white)
                    }
                    .background(Color.mainColor)
                    .cornerRadius(30)
                    .shadow(color: .black, radius: 5, x: 0, y: 5)

                    HStack(spacing: 4) {
                        Text("Already Have Account?")
                            .foregroundColor(.secondary)
                            .font(.footnote)

                        Button(action: {
                            onLoginTap()
                        }) {
                            Text("Log In")
                                .foregroundColor(Color.mainColor)
                                .font(.footnote)
                                .underline()
                        }
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 32)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
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
