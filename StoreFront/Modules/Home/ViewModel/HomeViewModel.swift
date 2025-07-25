//
//  HomeViewModel.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//
import Foundation
import RxSwift
import RxCocoa

final class HomeViewModel: BaseViewModel {

    private let fetchProductsUseCase: FetchProductsUseCaseProtocol
    
    private var currentLimit = 7
    private let pageSize = 7
    
    private var lastFetchedCount = 0
    private var hasMoreData = true
    
    let products = BehaviorRelay<[ProductModel]>(value: [])
    let selectedTabIndex = BehaviorRelay<Int>(value: 0)
    
    let scrollOffset = PublishRelay<CGFloat>()
    
    init(fetchProductsUseCase: FetchProductsUseCaseProtocol) {
        self.fetchProductsUseCase = fetchProductsUseCase
        super.init()
        observeScrollForPagination()
    }
    
    /// Loads initial products (resetting pagination) and notifies completion
    func loadInitialProducts(completion: ((Bool) -> Void)? = nil) {
        currentLimit = pageSize
        hasMoreData = true
        lastFetchedCount = 0
        loadProducts(limit: currentLimit, isInitialLoad: true, completion: completion)
    }

    /// Loads more products for pagination
    func loadMoreProducts() {
        guard !isLoading.value, hasMoreData else { return }
        currentLimit += pageSize
        loadProducts(limit: currentLimit, isInitialLoad: false, completion: nil)
    }

    private func observeScrollForPagination() {
        scrollOffset
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(products) { (distanceFromBottom, currentProducts) -> Bool in
                let shouldLoadMore = distanceFromBottom < LayoutMetrics.paginationThreshold
                return shouldLoadMore && !currentProducts.isEmpty && !self.isLoading.value && self.hasMoreData
            }
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.loadMoreProducts()
            })
            .disposed(by: disposeBag)
    }

    private func loadProducts(limit: Int, isInitialLoad: Bool, completion: ((Bool) -> Void)?) {
        
        isLoading.accept(true)
        
        fetchProductsUseCase.execute(limit: limit)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onNext: { [weak self] result in
                    guard let self = self else { return }
                    
                    let fetchedProducts = result.products
            
                    if !result.isFromCache {
                        if fetchedProducts.count == self.lastFetchedCount {
                            self.hasMoreData = false
                        }
                        self.lastFetchedCount = fetchedProducts.count
                    }
                    
                    if isInitialLoad {
                     
                        self.products.accept(fetchedProducts)
                    } else {
                       
                        let current = self.products.value
                        let newItems = fetchedProducts.dropFirst(current.count)
                        let updated = current + newItems
                        self.products.accept(updated)
                    }
                    
                    completion?(true)
                },
                onError: { [weak self] error in
                    self?.handleError(error)
                    completion?(false)
                },
                onCompleted: { [weak self] in
                    self?.isLoading.accept(false)
                }
            )
            .disposed(by: disposeBag)
    }

}
