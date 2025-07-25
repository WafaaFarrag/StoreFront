//
//  HomeSectionModel.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import RxDataSources

enum HomeSectionModel {
    case productsSection(items: [ProductModel])
}

extension HomeSectionModel: AnimatableSectionModelType {
    typealias Item = ProductModel
    
    var identity: String {
        switch self {
        case .productsSection:
            return "productsSection"
        }
    }
    
    var items: [ProductModel] {
        switch self {
        case .productsSection(let items):
            return items
        }
    }
    
    init(original: HomeSectionModel, items: [ProductModel]) {
        switch original {
        case .productsSection:
            self = .productsSection(items: items)
        }
    }
}
