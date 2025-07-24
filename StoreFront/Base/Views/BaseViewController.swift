//
//  BaseViewController.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    
    var disposeBag = DisposeBag()

    func bindLoading(_ loading: BehaviorRelay<Bool>, on targetView: UIView) {
        loading
            .asDriver()
            .drive(onNext: { isLoading in
                if isLoading {
                    LoadingService.show(on: targetView)
                } else {
                    LoadingService.hide(from: targetView)
                }
            })
            .disposed(by: disposeBag)
    }

    func showSuccess(message: String) {
        SwiftMessagesService.show(message: message, theme: .success)
    }
    
    func showError(message: String) {
        SwiftMessagesService.show(message: message, theme: .error)
    }
}

