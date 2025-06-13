//
//  SplashView.swift
//  FinanceTracker
//
//  Created by Doolot on 10/6/25.
//

import SwiftUI

struct SplashView: View {
    var onFinish: () -> Void

    private let title = "FinanceTracker"
    @State private var visibleIndices: Set<Int> = []

    var body: some View {
        ZStack {
            Color.mainColor.ignoresSafeArea()

            HStack(spacing: 0) {
                ForEach(Array(title.enumerated()), id: \.offset) { index, letter in
                    Text(String(letter))
                        .font(.system(size: 48, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .opacity(visibleIndices.contains(index) ? 1 : 0)
                        .offset(y: visibleIndices.contains(index)
                                ? 0
                                : (index % 2 == 0 ? -80 : 80)) // сверху или снизу
                        .animation(
                            .interpolatingSpring(stiffness: 200, damping: 18)
                                .delay(Double(index) * 0.05),
                            value: visibleIndices
                        )
                }
            }
        }
        .onAppear {
            for (index, _) in title.enumerated() {
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.05) {
                    visibleIndices.insert(index)
                }
            }

            // Завершение после всей анимации
            let totalDuration = Double(title.count) * 0.05 + 1.5
            DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    visibleIndices.removeAll()
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    onFinish()
                }
            }
        }
    }
}
#Preview {
    SplashView(onFinish: {
        print("Splash finished")
    })
}
