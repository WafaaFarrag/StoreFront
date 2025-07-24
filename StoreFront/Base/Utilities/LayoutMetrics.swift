//
//  LayoutMetrics.swift
//  StoreFront
//
//  Created by wafaa farrag on 24/07/2025.
//

import Foundation
import UIKit

struct LayoutMetrics {
    static let cornerRadius: CGFloat = 12
    static let gridColumns: CGFloat = 3
    static let gridSpacing: CGFloat = 8
    static let sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    static let listCellHeight: CGFloat = 250
    static let paginationThreshold: CGFloat = 200
    static let placeholderImage = UIImage(named: "placeholder")
    
    struct Fonts {
        static let title = UIFont(name: "Nunito-Bold", size: 14) ?? .systemFont(ofSize: 14)
        static let category = UIFont(name: "Nunito-Regular", size: 12) ?? .systemFont(ofSize: 12)
        static let price = UIFont(name: "Nunito-ExtraBold", size: 16) ?? .systemFont(ofSize: 16)
        static let rating = UIFont(name: "Nunito-Regular", size: 12) ?? .systemFont(ofSize: 12)
    }
    
    struct TabBar {
        static let backgroundColor = UIColor.white
        static let tintColor = UIColor(named: "redPrimary") ?? .systemRed
        static let unselectedTintColor = UIColor.lightGray
        static let homeIcon = "homeIcon"
        static let homeSelectedIcon = "homeSelectedIcon"
        static let cartIcon = "cartIcon"
        static let cartSelectedIcon = "cartSelectedIcon"
    }
}
