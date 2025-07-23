//
//  FetchProductsUseCase.swift
//  StoreFront
//
//  Created by wafaa farrag on 26/04/2025.
//

import Foundation
import RxSwift

protocol FetchProductsUseCaseProtocol {
    func execute(limit: Int) -> Single<[Product]>
}

class FetchProductsUseCase: BaseUseCase, FetchProductsUseCaseProtocol {

    private let repository: ProductsRepositoryProtocol
    
    init(repository: ProductsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute(limit: Int) -> Single<[Product]> {
        return repository.fetchProducts(limit: limit)
    }
}
