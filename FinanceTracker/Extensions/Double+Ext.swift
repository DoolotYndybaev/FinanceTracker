//
//  Double+Ext.swift
//  FinanceTracker
//
//  Created by Doolot on 8/9/25.
//

import Foundation

extension Double {
    /// Округляет число типа Double до заданного количества знаков после запятой
    /// - Parameter places: Количество знаков после запятой
    /// - Returns: Новое округлённое значение типа Double
    func rounded(toPlaces places: Int) -> Double {
        // 1. Вычисляем множитель: 10 в степени `places`
        // Например, если places = 2 → factor = 100.0
        let factor = pow(10.0, Double(places))
        
        // 2. Умножаем исходное число на этот множитель
        // Пример: 12.3456 * 100 = 1234.56
        let scaledValue = self * factor
        
        // 3. Округляем до ближайшего целого
        // Пример: round(1234.56) = 1235.0
        let roundedValue = scaledValue.rounded()
        
        // 4. Делим обратно на множитель, чтобы вернуть исходный масштаб
        // Пример: 1235.0 / 100 = 12.35
        return roundedValue / factor
    }
}
