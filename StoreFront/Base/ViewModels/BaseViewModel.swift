//
//  BaseViewModel.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import Foundation
import RxSwift
import RxCocoa


class BaseViewModel {
    let isLoading = BehaviorRelay<Bool>(value: false)
    let error = PublishSubject<String>()
    let disposeBag = DisposeBag()

    func handleError(_ error: Error) {
        let networkError = NetworkError.map(error)
        let message = networkError.localizedDescription
        SwiftMessagesService.show(message: message, theme: .error)
    }
}
