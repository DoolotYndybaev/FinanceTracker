//
//  AppearanceConfigurator.swift
//  FinanceTracker
//
//  Created by Doolot on 14/7/25.
//


import UIKit

enum AppearanceConfigurator {
    static func configureTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()

        // Прозрачный фон + blur
        appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
        appearance.backgroundColor = .clear

        // Цвет иконок/текста в НЕвыбранных табах (системный динамический цвет)
        let normalColor = UIColor.secondaryLabel
        appearance.stackedLayoutAppearance.normal.iconColor = normalColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: normalColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .regular)
        ]

        // ✅ Цвет иконок/текста в ВЫБРАННЫХ табах — динамически в зависимости от темы
        let selectedColor = UIColor { trait in
            switch trait.userInterfaceStyle {
            case .dark:
                return .white // тёмная тема → белый активный таб
            default:
                return .black // светлая тема → чёрный активный таб
            }
        }

        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: selectedColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold)
        ]

        // Применение
        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = appearance
        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        // Скругления (если это нужно)
        tabBar.layer.cornerRadius = 16
        tabBar.layer.masksToBounds = true
    }
}
