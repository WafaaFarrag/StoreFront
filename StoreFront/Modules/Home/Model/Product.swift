//
//  Product.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import Foundation
import RxDataSources

struct Rating: Codable {
    let rate: Double
    let count: Int
}

struct Product: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
}

extension Product: IdentifiableType, Equatable {
    public var identity: String {
        return "\(id)"  
    }
    
    public static func == (lhs: Product, rhs: Product) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.price == rhs.price &&
               lhs.image == rhs.image &&
               lhs.category == rhs.category &&
               lhs.rating.rate == rhs.rating.rate &&
               lhs.rating.count == rhs.rating.count
    }
}
