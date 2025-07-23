//
//  DateFormatterHelper.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import Foundation

class DateFormatterHelper {
    static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMM yyyy"
        return formatter.string(from: date)
    }
}
