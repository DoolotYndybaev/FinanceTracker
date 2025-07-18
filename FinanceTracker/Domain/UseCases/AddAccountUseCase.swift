//
//  AddAccountUseCase.swift
//  FinanceTracker
//
//  Created by Doolot on 14/7/25.
//

import SwiftUI

final class AddAccountUseCase: AddAccountUseCaseProtocol {
    private let userService: UserDataServiceProtocol

    init(userService: UserDataServiceProtocol) {
        self.userService = userService
    }

    func execute(_ account: Account) throws {
        guard var user = userService.fetchUser() else {
            throw AddAccountError.noUserFound
        }

        user.accounts.append(account)
        try userService.saveUser(user)
    }
}

enum AddAccountError: Error {
    case noUserFound
}
