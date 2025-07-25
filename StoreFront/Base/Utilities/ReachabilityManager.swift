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
    static let reachabilityConnectionChanged = Notification.Name("ReachabilityConnectionChanged")
}

final class ReachabilityManager {
    static let shared = ReachabilityManager()
    
    let monitor = NWPathMonitor()
    
    private let queue = DispatchQueue(label: "ReachabilityMonitor")
    private(set) var isConnected: Bool = true
    
    private init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            let newStatus = (path.status == .satisfied)
            if newStatus != self.isConnected {
                self.isConnected = newStatus
                
                DispatchQueue.main.async {
                    
                    NotificationCenter.default.post(
                        name: .reachabilityConnectionChanged,
                        object: nil,
                        userInfo: ["isConnected": newStatus]
                    )

                    
                    if !newStatus {
                        SwiftMessagesService.show(
                            message: "errorNoInternet".localized(),
                            theme: .error
                        )
                    } else {
                        SwiftMessagesService.show(
                            message: "Internet Restored".localized(),
                            theme: .success
                        )
                    }
                }
            }
        }
        monitor.start(queue: queue)
    }
    
    func verifyInternetAccess(completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://www.apple.com/library/test/success.html") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        request.timeoutInterval = 3
        
        URLSession.shared.dataTask(with: request) { _, response, error in
            let hasInternet = (response as? HTTPURLResponse)?.statusCode == 200 && error == nil
            DispatchQueue.main.async {
                completion(hasInternet)
            }
        }.resume()
    }

}
