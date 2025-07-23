//
//  AppEnvironment.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import Foundation

enum AppEnvironment {
    static let current: Environment = .staging

    enum Environment {
        case staging
        case production
  
        var baseURL: String {
            switch self {
            case .staging, .production : return "https://fakestoreapi.com"
            
            }
        }
        
        
    }
}
