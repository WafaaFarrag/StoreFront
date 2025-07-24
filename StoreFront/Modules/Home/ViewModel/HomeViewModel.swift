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
    
    let products = BehaviorRelay<[Product]>(value: [])
    let selectedTabIndex = BehaviorRelay<Int>(value: 0)
    
    let scrollOffset = PublishRelay<CGFloat>()
    
    init(fetchProductsUseCase: FetchProductsUseCaseProtocol) {
        self.fetchProductsUseCase = fetchProductsUseCase
        super.init()
        observeScrollForPagination()
    }
    
    func loadInitialProducts() {
        currentLimit = pageSize
        loadProducts(limit: currentLimit, isInitialLoad: true)
    }
    
    private func observeScrollForPagination() {
        scrollOffset
            .throttle(.milliseconds(300), scheduler: MainScheduler.instance)
            .withLatestFrom(products) { (distanceFromBottom, currentProducts) -> Bool in
                let shouldLoadMore = distanceFromBottom < LayoutMetrics.paginationThreshold
                return shouldLoadMore && !currentProducts.isEmpty && !self.isLoading.value
            }
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.loadMoreProducts()
            })
            .disposed(by: disposeBag)
    }
    
    private func loadMoreProducts() {
        currentLimit += pageSize
        loadProducts(limit: currentLimit, isInitialLoad: false)
    }
    
    private func loadProducts(limit: Int, isInitialLoad: Bool) {
        isLoading.accept(true)
        
        fetchProductsUseCase.execute(limit: limit)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let fetchedProducts):
                    if isInitialLoad {
                        self.products.accept(fetchedProducts)
                    } else {
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
