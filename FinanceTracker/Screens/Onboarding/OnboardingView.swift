//
//  OnboardingView.swift
//  FinanceTracker
//
//  Created by Doolot on 10/6/25.
//

import SwiftUI

struct OnboardingView: View {
    var onLoginTap: () -> Void
    var onGetStartedTap: () -> Void

    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 30) {
                ZStack {
                    Image.OnboardingImage.backgroundImage
                        .resizable()
                        .scaledToFit()
                        .clipped()
                        .ignoresSafeArea(edges: .top)
                        .frame(width: geometry.size.width * 1.2, height: geometry.size.height / 1.8)
                        .shadow(color: .black,
                                radius: 8,
                                x: 0,
                                y: 20)
                    
                    Capsule()
                        .fill(Color.black.opacity(0.1))
                        .frame(width: geometry.size.width * 0.5, height: 2)
                        .blur(radius: 0.5)
                        .offset(y: geometry.size.height * 0.277)

                    Image.OnboardingImage.onboardingMan
                        .resizable()
                        .scaledToFit()
                        .frame(height: geometry.size.height * 0.55)

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
                    
                    PrimaryButton(title: "Get Started") {
                        onGetStartedTap()
                    }

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
        print("onLoginTap")
    } onGetStartedTap: {
        print("onGetStartedTap")
    }
}
