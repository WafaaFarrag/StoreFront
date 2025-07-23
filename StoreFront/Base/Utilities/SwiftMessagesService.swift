//
//  SwiftMessagesService.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import Foundation

import SwiftMessages

class SwiftMessagesService {
    static func show(message: String, theme: Theme = .error) {
        let view = MessageView.viewFromNib(layout: .messageView)
        view.configureTheme(theme)
        view.configureContent(title: "" , body: message)
        view.button?.isHidden = true
        SwiftMessages.show(view: view)
    }
}
