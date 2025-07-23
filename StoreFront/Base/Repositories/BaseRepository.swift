//
//  BaseRepository.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import Foundation
import RxSwift

class BaseRepository {
    let api = APIManager.shared

    func fetch<T: Decodable>(_ target: APITarget, as type: T.Type) -> Single<T> {
        if !ReachabilityManager.shared.isConnected {
            return Single.error(NetworkError.noInternet)
        }
        
        return api.request(target, type: type)
    }
}
