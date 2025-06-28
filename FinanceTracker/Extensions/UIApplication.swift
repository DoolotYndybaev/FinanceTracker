//
//  UIApplication.swift
//  FinanceTracker
//
//  Created by Doolot on 28/6/25.
//

import UIKit

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
