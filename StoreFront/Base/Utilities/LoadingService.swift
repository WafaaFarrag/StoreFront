//
//  LoadingService.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import UIKit
import SkeletonView

import SkeletonView

final class LoadingService {
    
    static func show(on view: UIView) {
        let gradient = SkeletonGradient(baseColor: .systemGray5, secondaryColor: .systemGray4)
        view.showAnimatedGradientSkeleton(usingGradient: gradient, transition: .crossDissolve(0.25))
    }

    static func hide(from view: UIView) {
        view.hideSkeleton(transition: .crossDissolve(0.25))
    }
}

