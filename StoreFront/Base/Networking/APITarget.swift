//
//  APITarget.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import Moya

enum APITarget {
    case getProducts
    case getProductsWithLimit(limit: Int)
}

extension APITarget: TargetType {
    
    var baseURL: URL {
        if let savedURL = KeychainManager.load(forKey: "api_base_url"),
           let url = URL(string: savedURL), !savedURL.isEmpty {
            return url
        }
        return URL(string: "https://fakestoreapi.com")!
    }

    var path: String {
        switch self {
        case .getProducts, .getProductsWithLimit:
            return "/products"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getProducts:
            return .requestPlain
        case .getProductsWithLimit(let limit):
            return .requestParameters(parameters: ["limit": limit], encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
}
