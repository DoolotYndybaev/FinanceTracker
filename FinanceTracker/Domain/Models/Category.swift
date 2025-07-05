//
//  Category.swift
//  FinanceTracker
//
//  Created by Doolot on 9/6/25.
//

import Foundation

struct Category: Identifiable, Hashable, Codable {
    let id: UUID
    let name: String
    let icon: String
    let isIncome: Bool

    init(name: String, icon: String = "💰", isIncome: Bool) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.isIncome = isIncome
    }

    static let `default` = Category(name: "Uncategorized", icon: "❓", isIncome: false)
}

extension Category {
    init(
        id: UUID,
        name: String,
        icon: String,
        isIncome: Bool
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.isIncome = isIncome
    }
}
