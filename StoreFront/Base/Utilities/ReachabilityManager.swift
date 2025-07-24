//
//  ReachabilityManager.swift
//  StoreFront
//
//  Created by Wafaa Farrag on 20/07/2025.
//
//

import Network

final class ReachabilityManager {
    static let shared = ReachabilityManager()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ReachabilityMonitor")
    
    private(set) var isConnected: Bool = true
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = (path.status == .satisfied)
            
            if path.status == .satisfied {
               
            } else {
              
                DispatchQueue.main.async {
                    SwiftMessagesService.show(message: "No Internet Connection", theme: .error)
                }
            }
        }
        monitor.start(queue: queue)
    }
}
