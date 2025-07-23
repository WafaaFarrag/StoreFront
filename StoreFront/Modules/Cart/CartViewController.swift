//
//  CartViewController.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import UIKit

class CartViewController: UIViewController {

    private let messageLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "cartTab".localized()
        setupViews()
    }
    
    private func setupViews() {
        messageLabel.text = "emptyCartMessage".localized()
        messageLabel.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        messageLabel.textColor = .lightGray
        messageLabel.textAlignment = .center
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(messageLabel)
        
        NSLayoutConstraint.activate([
            messageLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}
