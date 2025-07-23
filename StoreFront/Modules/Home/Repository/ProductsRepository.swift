//
//  ProductsRepository.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import Foundation
import RxSwift

protocol ProductsRepositoryProtocol {
    func fetchProducts() -> Single<[Product]>
    func fetchProducts(limit: Int) -> Single<[Product]>
}


class ProductsRepository: BaseRepository, ProductsRepositoryProtocol {
    
    func fetchProducts() -> Single<[Product]> {
        return fetch(.getProducts, as: [Product].self)
    }
    
    func fetchProducts(limit: Int) -> Single<[Product]> {
        return fetch(.getProductsWithLimit(limit: limit), as: [Product].self)
    }
}
