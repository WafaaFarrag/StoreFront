//
//  AppDIContainer.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import Foundation

final class AppDIContainer {
    
    static let shared = AppDIContainer()
    private init() {}
    
    func makeProductsRepository() -> ProductsRepositoryProtocol {
        return ProductsRepository()
    }
    
    func makeFetchProductsUseCase() -> FetchProductsUseCase {
        return FetchProductsUseCase(repository: makeProductsRepository())
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(
            fetchProductsUseCase: makeFetchProductsUseCase()
        )
    }
}
