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

struct ProductModel: Codable {
    let id: Int
    let title: String
    let price: Double
    let description: String
    let category: String
    let image: String
    let rating: Rating
}

extension ProductModel: IdentifiableType, Equatable {
    public var identity: String {
        return "\(id)"  // id is used as the unique identifier
    }
    
    public static func == (lhs: ProductModel, rhs: ProductModel) -> Bool {
        return lhs.id == rhs.id &&
               lhs.title == rhs.title &&
               lhs.price == rhs.price &&
               lhs.image == rhs.image &&
               lhs.category == rhs.category &&
               lhs.rating.rate == rhs.rating.rate &&
               lhs.rating.count == rhs.rating.count
    }
}

struct ProductResult {
    let products: [ProductModel]
    let isFromCache: Bool
}
