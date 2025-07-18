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

        // Цвет фона — прозрачный + blur эффект
        appearance.backgroundEffect = UIBlurEffect(style: .systemMaterial)
        appearance.backgroundColor = UIColor.clear

        // Цвет иконок/текста в НЕвыбранных табах
        let normalColor = UIColor.secondaryLabel
        appearance.stackedLayoutAppearance.normal.iconColor = normalColor
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [
            .foregroundColor: normalColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .regular)
        ]

        // Цвет иконок/текста в выбранных табах
        let selectedColor = UIColor.black
        appearance.stackedLayoutAppearance.selected.iconColor = selectedColor
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: selectedColor,
            .font: UIFont.systemFont(ofSize: 11, weight: .semibold)
        ]

        // Применяем
        let tabBar = UITabBar.appearance()
        tabBar.standardAppearance = appearance

        if #available(iOS 15.0, *) {
            tabBar.scrollEdgeAppearance = appearance
        }

        // Скругления + тень (через CALayer, если нужно кастомно)
        tabBar.layer.cornerRadius = 16
        tabBar.layer.masksToBounds = true
    }
}
