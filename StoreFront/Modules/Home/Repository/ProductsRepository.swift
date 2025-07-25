//
//  ProductsRepository.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import Foundation
import RxSwift

protocol ProductsRepositoryProtocol {
    func fetchProducts(limit: Int?) -> Observable<ProductResult>
}

final class ProductsRepository: BaseRepository, ProductsRepositoryProtocol {

    func fetchProducts(limit: Int? = nil) -> Observable<ProductResult> {
        let cachedObservable = Observable<ProductResult>.create { observer in
            var cachedProducts = CacheManager.shared.loadCachedProducts()
            cachedProducts.sort { $0.id < $1.id }
            if !cachedProducts.isEmpty {
                observer.onNext(ProductResult(products: cachedProducts, isFromCache: true))
            }
            observer.onCompleted()
            return Disposables.create()
        }

        let endpoint: APITarget = .getProductsWithLimit(limit: limit ?? 7)
        let networkObservable = fetch(endpoint, as: [ProductModel].self)
            .asObservable()
            .map { products -> ProductResult in
                let sorted = products.sorted { $0.id < $1.id }
                return ProductResult(products: sorted, isFromCache: false)
            }
            .do(onNext: { result in
                CacheManager.shared.saveProducts(result.products)
            })
            .catch { error in
                var cached = CacheManager.shared.loadCachedProducts()
                cached.sort { $0.id < $1.id }
                return cached.isEmpty
                    ? .error(error)
                    : .just(ProductResult(products: cached, isFromCache: true))
            }

        return Observable.concat(cachedObservable, networkObservable)
    }
}
