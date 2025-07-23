//
//  HomeViewModel.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import Foundation
import RxSwift
import RxCocoa

class HomeViewModel: BaseViewModel {
    
    private let fetchProductsUseCase: FetchProductsUseCaseProtocol
    
    private var currentLimit = 7
    private let pageSize = 7
    
    let products = BehaviorRelay<[Product]>(value: [])
    let selectedTabIndex = BehaviorRelay<Int>(value: 0)
    
    init(fetchProductsUseCase: FetchProductsUseCaseProtocol) {
        self.fetchProductsUseCase = fetchProductsUseCase
        super.init()
    }
    
    // MARK: - Initial Load
    func loadInitialProducts() {
        currentLimit = pageSize
        loadProducts(limit: currentLimit, isInitialLoad: true)
    }
    
    // MARK: - Load More
    func loadMoreProducts() {
        guard !isLoading.value else { return } // prevent double load
        
        currentLimit += pageSize
        loadProducts(limit: currentLimit, isInitialLoad: false)
    }
    
    // MARK: - Private API Call
    private func loadProducts(limit: Int, isInitialLoad: Bool) {
        isLoading.accept(true)
        
        fetchProductsUseCase.execute(limit: limit)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let fetchedProducts):
                    
                    if isInitialLoad {
                        // First load → replace
                        self.products.accept(fetchedProducts)
                    } else {
                        //  Pagination → append only the new batch
                        let newItems = fetchedProducts.suffix(self.pageSize)
                        var current = self.products.value
                        current.append(contentsOf: newItems)
                        self.products.accept(current)
                    }
                    
                case .failure(let error):
                    self.handleError(error)
                }
                
                self.isLoading.accept(false)
            }
            .disposed(by: disposeBag)
    }
}

