//
//  ProfileView.swift
//  FinanceTracker
//
//  Created by Doolot on 28/7/25.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 32) {
                    if let user = viewModel.user {
                        // 🧍 Профиль пользователя
                        VStack(spacing: 12) {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.blue)
                                .shadow(radius: 4)

                            Text(user.name)
                                .font(.title)
                                .fontWeight(.semibold)

                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemGray6))
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 4)
                        )
                        .padding(.horizontal)

                        // ⚙️ Настройки и действия
                        VStack(spacing: 1) {
                            ProfileRow(icon: "key.fill", title: "Change Password") {
                                // TODO: Навигация
                            }

                            ProfileRow(icon: "gearshape.fill", title: "Settings") {
                                // TODO: Навигация
                            }

                            ProfileRow(icon: "rectangle.portrait.and.arrow.right", title: "Log out", isDestructive: true) {
                                viewModel.logout()
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color(.systemGray6))
                                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 4)
                        )
                        .padding(.horizontal)
                    } else {
                        ProgressView("Загрузка профиля...")
                    }

                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("Profile")
        }
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String
    var isDestructive: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .foregroundColor(isDestructive ? .red : .blue)
                    .frame(width: 24)

                Text(title)
                    .foregroundColor(isDestructive ? .red : .primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
        }
    }
}
