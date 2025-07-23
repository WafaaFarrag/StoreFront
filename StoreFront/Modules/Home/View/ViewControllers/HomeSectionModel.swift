//
//  HomeSectionModel.swift
//  StoreFront
//
//  Created by wafaa farrag on 20/07/2025.
//

import RxDataSources

enum HomeSectionModel {
    case productsSection(items: [Product])
}

extension HomeSectionModel: SectionModelType {
    typealias Item = Product  
    
    var items: [Product] {
        switch self {
        case .productsSection(let items):
            return items
        }
    }
    
    init(original: HomeSectionModel, items: [Product]) {
        switch original {
        case .productsSection:
            self = .productsSection(items: items)
        }
    }
}
