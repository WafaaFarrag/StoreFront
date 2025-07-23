//
//  Int+Extensions.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import Foundation

extension Int {
    func localizedString() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
