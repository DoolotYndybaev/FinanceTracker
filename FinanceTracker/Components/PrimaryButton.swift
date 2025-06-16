//
//  PrimaryButton.swift
//  FinanceTracker
//
//  Created by Doolot on 14/6/25.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isEnabled: Bool = true
    var isLoading: Bool = false
    var icon: String? = nil // SF Symbol name
    var iconPosition: IconPosition = .leading

    enum IconPosition {
        case leading, trailing
    }

    var body: some View {
        Button(action: {
            if isEnabled && !isLoading {
                action()
            }
        }) {
            HStack(spacing: 8) {
                if let icon, iconPosition == .leading {
                    Image(systemName: icon)
                }

                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                } else {
                    Text(title)
                        .font(.headline)
                }

                if let icon, iconPosition == .trailing {
                    Image(systemName: icon)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(isEnabled ? Color.mainColor : Color.gray.opacity(0.5))
            .cornerRadius(30)
            .shadow(color: .black.opacity(isEnabled ? 0.3 : 0.0),
                    radius: 5,
                    x: 0,
                    y: 5)
            .scaleEffect(isEnabled ? 1.0 : 0.98)
            .animation(.easeInOut(duration: 0.15), value: isEnabled)
        }
        .disabled(!isEnabled || isLoading)
    }
}
