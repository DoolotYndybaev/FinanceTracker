//
//  SplashView.swift
//  FinanceTracker
//
//  Created by Doolot on 10/6/25.
//

import SwiftUI

struct SplashView: View {
    var onFinish: () -> Void

    @State private var scale: CGFloat = 0.0
    @State private var opacity: Double = 0.0

    var body: some View {
        ZStack {
            Color.mainColor.edgesIgnoringSafeArea(.all)


            Text("FinanceTracker")
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundColor(.white)
                .scaleEffect(scale)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeOut(duration: 0.8)) {
                        scale = 1.0
                        opacity = 1.0
                    }

                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            scale = 0.0
                            opacity = 0.0
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            onFinish()
                        }
                    }
                }
        }
    }
}
