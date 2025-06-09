//
//  Category.swift
//  FinanceTracker
//
//  Created by Doolot on 9/6/25.
//

import Foundation

struct Category: Identifiable, Hashable {
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
}
