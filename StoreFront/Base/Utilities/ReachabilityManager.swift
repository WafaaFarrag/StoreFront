//
//  ReachabilityManager.swift
//  StoreFront
//
//  Created by Wafaa Farrag on 20/07/2025.
//
//

import Network
import UIKit

extension Notification.Name {
    static let networkRestored = Notification.Name("networkRestored")
}

final class ReachabilityManager {
    static let shared = ReachabilityManager()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "ReachabilityMonitor")
    
    private(set) var isConnected: Bool = true
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            let nowConnected = (path.status == .satisfied)
            
            // Network just restored → notify observers
            if nowConnected && !self.isConnected {
                NotificationCenter.default.post(name: .networkRestored, object: nil)
            }
            
            self.isConnected = nowConnected
        }
        
        monitor.start(queue: queue)
    }
}
