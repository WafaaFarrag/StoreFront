
//
//  NetworkError.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//
import Foundation
import Moya

enum NetworkError: Error, LocalizedError {
    
    case server(statusCode: Int, message: String?)
    case decoding
    case noInternet
    case timeout
    case cancelled
    case unauthorized
    case notFound
    case unknown
    
    static func map(_ error: Error) -> NetworkError {
        
        if let networkError = error as? NetworkError {
            return networkError
        }
        
        if !ReachabilityManager.shared.isConnected {
            return .noInternet
        }
        
        if let moyaError = error as? MoyaError {
            switch moyaError {
            case .statusCode(let response):
                let status = response.statusCode
                switch status {
                case 401, 403:
                    return .unauthorized
                case 404:
                    return .notFound
                case 500...599:
                    return .server(statusCode: status, message: "Server internal error")
                default:
                    return .server(statusCode: status, message: "HTTP Error \(status)")
                }
                
            case .underlying(let nsError as NSError, _):
                if !ReachabilityManager.shared.isConnected {
                              return .noInternet
                }
                switch nsError.code {
                case NSURLErrorNotConnectedToInternet:
                    return .noInternet
                case NSURLErrorTimedOut:
                    return .timeout
                case NSURLErrorCancelled:
                    return .cancelled
                default:
                    return .server(statusCode: nsError.code, message: nsError.localizedDescription)
                }
                
            case .objectMapping, .encodableMapping, .jsonMapping:
                return .decoding
                
            default:
                return .unknown
            }
        }
        
        let nsError = error as NSError
        switch nsError.code {
        case NSURLErrorNotConnectedToInternet:
            return .noInternet
        case NSURLErrorTimedOut:
            return .timeout
        case NSURLErrorCancelled:
            return .cancelled
        default:
            break
        }
        
        if !ReachabilityManager.shared.isConnected {
            return .noInternet
        }
        
        return .unknown
    }
    
    var errorDescription: String? {
        switch self {
        case .server(_, let message):
            return message ?? NSLocalizedString("errorServer", comment: "")
        case .decoding:
            return NSLocalizedString("errorDecoding", comment: "")
        case .noInternet:
            return NSLocalizedString("errorNoInternet", comment: "")
        case .timeout:
            return NSLocalizedString("errorTimeout", comment: "")
        case .cancelled:
            return NSLocalizedString("errorCancelled", comment: "")
        case .unauthorized:
            return NSLocalizedString("errorUnauthorized", comment: "")
        case .notFound:
            return NSLocalizedString("errorNotFound", comment: "")
        case .unknown:
            return NSLocalizedString("errorUnknown", comment: "")
        }
    }
}
